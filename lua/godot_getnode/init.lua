-- godot_getnode/init.lua
-- Two completion features for Godot projects (C# or F# siblings):
--
--   1. GetNode / GetNodeOrNull path + generic  (C# files inside the Godot project)
--   2. res:// file paths inside any string     (C# or F# anywhere in the solution)
--
-- Supported GetNode patterns (cursor must be inside the string):
--   GetNode("partial           → inserts <Type> + completes path
--   GetNode<>("partial         → fills empty <> with Type + completes path
--   GetNode<T>("partial        → completes path only (generic untouched)
--   GetNodeOrNull variants of all the above

local M = {}

-- ============================================================================
-- Cache
-- ============================================================================

-- Per-scene-file:  abs_path → { mtime, nodes[] }
local _scene_cache = {}

-- Per-script:      res_path → { time, scene_paths[] }   (10 s TTL)
local _scenes_for_script = {}

-- Per-buffer:      bufnr    → project_root string | false
local _root_cache = {}

-- Per-project:     project_root → { time, entries[] }   (5 s TTL)
local _project_cache = {}
local PROJECT_CACHE_TTL = 5

local function get_mtime(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.mtime.sec or 0
end

-- ============================================================================
-- Project Root Detection
-- ============================================================================

--- Locate the Godot project root (directory containing project.godot).
---
--- Two-pass strategy to handle solution layouts like:
---
---   MyGame.sln
---   MyGame/          ← Godot project  (has project.godot)
---   MyGame.Logic/    ← F# project     (no project.godot above it)
---
--- Pass 1 – walk upward from start_path (works for files inside the Godot tree).
--- Pass 2 – walk upward until a *.sln is found, then search one level below it
---           for project.godot (handles sibling projects in a solution).
---
---@param start_path string  directory to begin the search from
---@return string|nil
local function find_project_root(start_path)
  -- ── Pass 1: direct upward walk ───────────────────────────────────────────
  local path = start_path
  for _ = 1, 30 do
    if vim.fn.filereadable(path .. '/project.godot') == 1 then
      return path
    end
    local parent = vim.fn.fnamemodify(path, ':h')
    if parent == path then
      break
    end
    path = parent
  end

  -- ── Pass 2: find the solution root, then search siblings ─────────────────
  path = start_path
  for _ = 1, 30 do
    local slns = vim.fn.glob(path .. '/*.sln', false, true)
    if #slns > 0 then
      -- Look one level down for any sibling that contains project.godot
      local hits = vim.fn.glob(path .. '/*/project.godot', false, true)
      if #hits > 0 then
        -- Use the first match (there should only be one Godot project per sln)
        return vim.fn.fnamemodify(hits[1], ':h')
      end
      break -- found a .sln but no Godot sibling — stop searching
    end
    local parent = vim.fn.fnamemodify(path, ':h')
    if parent == path then
      break
    end
    path = parent
  end

  return nil
end

--- Cached wrapper around find_project_root.
--- Result is stored per buffer so the filesystem walk only runs once.
---@param bufnr integer
---@return string|nil
local function get_project_root(bufnr)
  local cached = _root_cache[bufnr]
  if cached ~= nil then
    return cached ~= false and cached or nil
  end
  local file_path = vim.api.nvim_buf_get_name(bufnr)
  local dir = vim.fn.fnamemodify(file_path, ':h')
  local root = find_project_root(dir)
  _root_cache[bufnr] = root or false -- store false so nil result is cached too
  return root
end

--- Convert an absolute filesystem path to a Godot res:// path.
---@param project_root string
---@param abs_path string
---@return string
local function to_res_path(project_root, abs_path)
  return 'res://' .. abs_path:sub(#project_root + 2)
end

-- ============================================================================
-- .tscn Parser
-- ============================================================================

--- Parse a Godot .tscn file and return a list of scene-child nodes.
--- Each entry: { path: string, tp: string, name: string }
---   path  – relative to scene root, e.g. "Sprite2D/HealthBar"
---   tp    – Godot type name, e.g. "ProgressBar"
---@param scene_path string
---@return table[]
local function parse_scene(scene_path)
  local mtime = get_mtime(scene_path)
  local cached = _scene_cache[scene_path]
  if cached and cached.mtime == mtime then
    return cached.nodes
  end

  local f = io.open(scene_path, 'r')
  if not f then
    return {}
  end

  local raw = {}
  local root_done = false

  for line in f:lines() do
    if line:sub(1, 6) ~= '[node ' then
      goto continue
    end

    local name = line:match('name="([^"]+)"')
    local tp = line:match('type="([^"]+)"')
    local parent = line:match('parent="([^"]+)"')
    if not name then
      goto continue
    end

    if not tp then
      tp = line:match('instance=') and 'PackedScene' or 'Node'
    end

    if parent == nil and not root_done then
      root_done = true -- root node; skip it as a completion entry
    else
      table.insert(raw, { name = name, tp = tp, parent = parent or '.' })
    end
    ::continue::
  end
  f:close()

  -- Reconstruct full paths.
  -- parent "."    → direct child of root  → path = name
  -- parent "A/B" → path = "A/B/name"
  local result = {}
  for _, n in ipairs(raw) do
    local full = (n.parent == '.') and n.name or (n.parent .. '/' .. n.name)
    table.insert(result, { path = full, tp = n.tp, name = n.name })
  end

  _scene_cache[scene_path] = { mtime = mtime, nodes = result }
  return result
end

--- Find every .tscn in the project that references the given script path.
---@param project_root string
---@param res_path     string  e.g. "res://Player.cs"
---@return string[]
local function find_scenes_for_script(project_root, res_path)
  local entry = _scenes_for_script[res_path]
  if entry and (os.time() - entry.time) < 10 then
    return entry.scenes
  end

  -- rg -Fl: fixed-string, list filenames only, scoped to *.tscn
  local cmd = string.format("rg -Fl %q %q -g '*.tscn' 2>/dev/null", res_path, project_root)
  local handle = io.popen(cmd)
  local scenes = {}
  if handle then
    for line in handle:lines() do
      local t = vim.trim(line)
      if t ~= '' then
        table.insert(scenes, t)
      end
    end
    handle:close()
  end

  _scenes_for_script[res_path] = { time = os.time(), scenes = scenes }
  return scenes
end

-- ============================================================================
-- res:// File Lister
-- ============================================================================

--- Full recursive scan of the Godot project with fd.
--- Results are cached per project root for PROJECT_CACHE_TTL seconds.
--- fd respects .gitignore and skips hidden files by default.
---@param project_root string
---@return table[]  list of { path: string, is_dir: bool }
---                 path is relative to project_root, dirs have no trailing slash
local function scan_project(project_root)
  local cached = _project_cache[project_root]
  if cached and (os.time() - cached.time) < PROJECT_CACHE_TTL then
    return cached.entries
  end

  local cmd = string.format(
    "{ fd --type d --base-directory %q --color never 2>/dev/null | sed 's/^/d /';"
      .. " fd --type f --base-directory %q --color never 2>/dev/null | sed 's/^/f /'; }",
    project_root,
    project_root
  )

  local entries = {}
  local handle = io.popen(cmd)
  if handle then
    for line in handle:lines() do
      local tp, path = line:match('^([df]) (.+)$')
      if tp and path then
        path = path:gsub('/$', '')  -- fd appends / to dirs; tracked via is_dir
        table.insert(entries, { path = path, is_dir = tp == 'd' })
      end
    end
    handle:close()
  end

  _project_cache[project_root] = { time = os.time(), entries = entries }
  return entries
end

--- List files and directories under the Godot project whose res:// path starts
--- with the given partial (the portion after "res://").
---
--- All depths are searched so typing "res://" immediately surfaces deep paths.
--- Directories sort before files; within each group sorted alphabetically.
---
---@param project_root string
---@param partial      string  e.g. "" | "Entities/" | "Entities/Player/Sp"
---@return table[]  list of { full_res, rel_path, is_dir, name }
local function list_res_paths(project_root, partial)
  local all_entries = scan_project(project_root)

  local results = {}
  for _, entry in ipairs(all_entries) do
    local rel = entry.is_dir and (entry.path .. '/') or entry.path
    if partial == '' or rel:sub(1, #partial) == partial then
      table.insert(results, {
        full_res = 'res://' .. rel,
        rel_path = rel,
        is_dir = entry.is_dir,
        name = entry.path:match('[^/]+$') or entry.path,
      })
    end
  end

  table.sort(results, function(a, b)
    if a.is_dir ~= b.is_dir then
      return a.is_dir
    end
    return a.rel_path < b.rel_path
  end)

  return results
end

-- ============================================================================
-- Context Detection
-- ============================================================================

--- Detect a GetNode / GetNodeOrNull call with cursor inside the string argument.
---
---@param line       string   full line text
---@param cursor_col integer  0-indexed byte offset (bytes before cursor)
---@return table|nil
local function detect_getnode_context(line, cursor_col)
  local before = line:sub(1, cursor_col)

  -- Find the rightmost GetNode keyword (try longer variant first)
  local function find_last(kw)
    local pos, last = 1, nil
    while true do
      local f = before:find(kw, pos, true)
      if not f then
        break
      end
      last = f
      pos = f + 1
    end
    return last -- 1-indexed or nil
  end

  local kw_start1 = find_last('GetNodeOrNull')
  local kw_len = kw_start1 and 13 or nil
  if not kw_len then
    kw_start1 = find_last('GetNode')
    kw_len = kw_start1 and 7 or nil
  end
  if not kw_len then
    return nil
  end

  -- 0-indexed position of the char right after the keyword
  local kw_end0 = (kw_start1 - 1) + kw_len
  local rest = before:sub(kw_end0 + 1)

  -- Optional generic <TYPE>
  local generic_raw, inner_type, after_gen = rest:match('^(<([^>]*)>)(.*)')
  local has_generic = generic_raw ~= nil
  local existing_type = (has_generic and inner_type ~= '') and inner_type or nil
  local rest2 = has_generic and after_gen or rest

  local gen_start0 = kw_end0
  local gen_end0 = has_generic and (gen_start0 + #generic_raw - 1) or nil

  -- Must be followed by ("
  local path_prefix = rest2:match('^%("([^"]*)')
  if not path_prefix then
    return nil
  end

  local paren0 = has_generic and (gen_start0 + #generic_raw) or kw_end0
  local str_start0 = paren0 + 2 -- skip '(' and '"'

  return {
    path_prefix = path_prefix,
    has_generic = has_generic,
    existing_type = existing_type,
    str_start0 = str_start0,
    cursor0 = cursor_col,
    gen_start0 = gen_start0,
    gen_end0 = gen_end0,
    paren0 = paren0,
  }
end

--- Detect a res:// path literal with cursor inside the string.
---
--- Matches any `"res://partial` in the text before the cursor, regardless of
--- surrounding syntax — works in C#, F#, or any language.
---
---@param line       string   full line text
---@param cursor_col integer  0-indexed byte offset (bytes before cursor)
---@return table|nil  { partial_path, content_start0, cursor0 }
local function detect_res_context(line, cursor_col)
  local before = line:sub(1, cursor_col)

  -- Find the rightmost `"res://` opening before the cursor
  local quote_pos1 = nil -- 1-indexed position of the `"` character
  local p = 1
  while true do
    local f = before:find('"res://', p, true)
    if not f then
      break
    end
    quote_pos1 = f
    p = f + 1
  end
  if not quote_pos1 then
    return nil
  end

  -- Text from after the opening " to the cursor; must not contain a closing "
  local after_quote = before:sub(quote_pos1 + 1)
  if after_quote:find('"', 1, true) then
    return nil
  end

  -- Strip the "res://" prefix (6 chars) to get just the partial filesystem path
  local partial_path = after_quote:sub(7)

  -- 0-indexed start of the string content (the 'r' in 'res://'):
  -- opening " is at 1-indexed quote_pos1 = 0-indexed (quote_pos1 - 1)
  -- content starts one byte later = 0-indexed quote_pos1
  local content_start0 = quote_pos1

  return {
    partial_path = partial_path,
    content_start0 = content_start0,
    cursor0 = cursor_col,
  }
end

-- ============================================================================
-- Public API
-- ============================================================================

--- GetNode / GetNodeOrNull path completions.
--- Only meaningful for C# files inside (or sibling to) a Godot project.
---@param bufnr integer
---@param row0  integer  0-indexed row
---@param col0  integer  0-indexed cursor col
---@return table[]  LSP CompletionItem list
function M.get_getnode_completions(bufnr, row0, col0)
  local line = vim.api.nvim_buf_get_lines(bufnr, row0, row0 + 1, false)[1]
  if not line then
    return {}
  end

  local ctx = detect_getnode_context(line, col0)
  if not ctx then
    return {}
  end

  local project_root = get_project_root(bufnr)
  if not project_root then
    return {}
  end

  -- GetNode paths are relative to the scene, so we need the scenes that
  -- attach the CURRENT C# script. The script's identity is its res:// path.
  local file_path = vim.api.nvim_buf_get_name(bufnr)
  local res_path = to_res_path(project_root, file_path)
  local scene_files = find_scenes_for_script(project_root, res_path)

  local all_nodes = {}
  local seen = {}
  for _, sp in ipairs(scene_files) do
    for _, node in ipairs(parse_scene(sp)) do
      if not seen[node.path] then
        seen[node.path] = true
        table.insert(all_nodes, node)
      end
    end
  end

  local prefix = ctx.path_prefix
  local items = {}

  for _, node in ipairs(all_nodes) do
    if node.path:sub(1, #prefix) == prefix then
      local text_edit = {
        newText = node.path,
        range = {
          start = { line = row0, character = ctx.str_start0 },
          ['end'] = { line = row0, character = ctx.cursor0 },
        },
      }

      local additional = {}
      if not ctx.has_generic then
        table.insert(additional, {
          newText = '<' .. node.tp .. '>',
          range = {
            start = { line = row0, character = ctx.paren0 },
            ['end'] = { line = row0, character = ctx.paren0 },
          },
        })
      elseif not ctx.existing_type then
        table.insert(additional, {
          newText = '<' .. node.tp .. '>',
          range = {
            start = { line = row0, character = ctx.gen_start0 },
            ['end'] = { line = row0, character = ctx.gen_end0 + 1 },
          },
        })
      end

      table.insert(items, {
        label = node.path,
        kind = 12, -- Value
        detail = node.tp,
        filterText = node.path,
        sortText = node.path,
        textEdit = text_edit,
        additionalTextEdits = #additional > 0 and additional or nil,
      })
    end
  end

  return items
end

--- res:// path completions — works in any language (C#, F#, …).
--- The Godot project is found via the two-pass root detection.
---@param bufnr integer
---@param row0  integer  0-indexed row
---@param col0  integer  0-indexed cursor col
---@return table[]  LSP CompletionItem list
function M.get_res_completions(bufnr, row0, col0)
  local line = vim.api.nvim_buf_get_lines(bufnr, row0, row0 + 1, false)[1]
  if not line then
    return {}
  end

  local ctx = detect_res_context(line, col0)
  if not ctx then
    return {}
  end

  local project_root = get_project_root(bufnr)
  if not project_root then
    return {}
  end

  local entries = list_res_paths(project_root, ctx.partial_path)
  local items = {}

  for _, entry in ipairs(entries) do
    table.insert(items, {
      label = entry.full_res,
      kind = entry.is_dir and 19 or 17, -- Folder = 19, File = 17
      detail = entry.is_dir and 'directory' or nil,
      filterText = entry.full_res,
      -- Sort: dirs (0…) before files (1…), then alphabetical
      sortText = (entry.is_dir and '0' or '1') .. entry.name,
      textEdit = {
        newText = entry.full_res,
        range = {
          start = { line = row0, character = ctx.content_start0 },
          ['end'] = { line = row0, character = ctx.cursor0 },
        },
      },
    })
  end

  return items
end

-- Kept for backwards compatibility with the old single-function API.
M.get_completions = M.get_getnode_completions

-- ============================================================================
-- Setup
-- ============================================================================

function M.setup()
  local grp = vim.api.nvim_create_augroup('GodotGetNodeCache', { clear = true })

  -- Invalidate scene parse cache when a .tscn is saved
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = grp,
    pattern = '*.tscn',
    callback = function(ev)
      _scene_cache[ev.file] = nil
      _scenes_for_script = {}
      _project_cache = {}
    end,
  })

  -- Invalidate directory cache on any file write (picks up newly created assets)
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = grp,
    callback = function()
      _project_cache = {}
    end,
  })

  -- Evict per-buffer root cache when a buffer is wiped
  vim.api.nvim_create_autocmd('BufDelete', {
    group = grp,
    callback = function(ev)
      _root_cache[ev.buf] = nil
    end,
  })
end

return M
