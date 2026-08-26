-- godot_getnode/blink.lua
-- blink.cmp source exposing both GetNode path completions and res:// completions.
--
-- Register in your blink.cmp setup:
--
--   require("blink.cmp").setup({
--     sources = {
--       default = { "lsp", "path", "snippets", "buffer", "godot_getnode" },
--       providers = {
--         godot_getnode = {
--           name         = "GodotGetNode",
--           module       = "godot_getnode.blink",
--           score_offset = 100,
--           opts = {
--             -- Folders (top-level) and extension globs to exclude from res://.
--             -- Default is empty; configure here or override per project.
--             ignore = { "addons", "*.uid", "*.cs", "*.gd" }, -- example
--           },
--         },
--       },
--     },
--   })

local godot = require('godot_getnode')

---@class GodotGetNodeSource
---@field ignore string[]
local Source = {}
Source.__index = Source

---@param opts? { ignore?: string[] }
function Source.new(opts)
  opts = opts or {}
  return setmetatable({
    ignore = opts.ignore or {},
  }, Source)
end

--- Trigger characters so blink re-queries inside res:// paths and strings.
---@return string[]
function Source:get_trigger_characters()
  return { '/' }
end

--- Fast pre-filter: only activate when there is something to complete.
--- Handles both C# (GetNode + res://) and F# (res:// only).
---@param ctx blink.cmp.Context
---@return boolean
function Source:enabled(ctx)
  if not ctx then return true end
  local ft = vim.bo[ctx.bufnr].filetype
  if ft ~= 'cs' and ft ~= 'fsharp' then
    return false
  end

  local before = ctx.line:sub(1, ctx.cursor[2])

  if ft == 'cs' and before:find('GetNode', 1, true) then
    return true
  end
  if before:find('"res:/', 1, true) then
    return true
  end

  return false
end

--- Provide completions.
--- blink.cmp cursor convention (mirrors nvim_win_get_cursor):
---   ctx.cursor[1]  1-indexed row
---   ctx.cursor[2]  0-indexed byte column (= bytes before cursor on the line)
---@param ctx      blink.cmp.Context
---@param callback fun(response: table)
function Source:get_completions(ctx, callback)
  local row0 = ctx.cursor[1] - 1
  local col0 = ctx.cursor[2]
  local ft = vim.bo[ctx.bufnr].filetype

  local items = {}

  -- GetNode / GetNodeOrNull completions (C# only — F# has no GetNode API)
  if ft == 'cs' then
    vim.list_extend(items, godot.get_getnode_completions(ctx.bufnr, row0, col0))
  end

  -- res:// path completions (C# and F#), filtered by ignore list
  local res_items = godot.get_res_completions(ctx.bufnr, row0, col0)
  if #self.ignore > 0 then
    for _, item in ipairs(res_items) do
      local ignored = false
      for _, pattern in ipairs(self.ignore) do
        if pattern:sub(1, 1) == '*' then
          -- Extension glob: "*.uid" → reject any label ending with ".uid"
          local suffix = pattern:sub(2)
          if #suffix > 0 and item.label:sub(-#suffix) == suffix then
            ignored = true
            break
          end
        else
          -- Top-level folder: "addons" → reject "res://addons/..."
          if item.label:find('res://' .. pattern .. '/', 1, true) == 1 then
            ignored = true
            break
          end
        end
      end
      if not ignored then
        table.insert(items, item)
      end
    end
  else
    vim.list_extend(items, res_items)
  end

  -- Re-trigger after selecting a directory so the next path segment completes.
  local has_dir = false
  for _, item in ipairs(items) do
    if item.kind == 19 then
      has_dir = true
      break
    end
  end

  callback({
    is_incomplete_forward = has_dir,
    is_incomplete_backward = false,
    items = items,
  })
end

return Source
