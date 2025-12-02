local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- Function to find the project root by looking for .csproj file
local function find_project_root(filepath)
  local dir = vim.fn.fnamemodify(filepath, ':h')
  while dir ~= '/' do
    local files = vim.fn.glob(dir .. '/*.csproj', false, true)
    if #files > 0 then
      return dir
    end
    dir = vim.fn.fnamemodify(dir, ':h')
  end
  return nil
end

-- Function to get namespace from file path
local function get_namespace()
  local filepath = vim.fn.expand('%:p')
  local project_root = find_project_root(filepath)

  if not project_root then
    return 'YourNamespace'
  end

  local relative_path = filepath:sub(#project_root + 2) -- +2 to remove leading /
  local dir_path = vim.fn.fnamemodify(relative_path, ':h')

  if dir_path == '.' or dir_path == '' then
    -- File is in project root
    local project_name = vim.fn.fnamemodify(vim.fn.glob(project_root .. '/*.csproj'), ':t:r')
    return project_name
  end

  -- Convert directory path to namespace (replace / with .)
  local namespace = dir_path:gsub('/', '.')

  -- Get project name and prepend it
  local project_name = vim.fn.fnamemodify(vim.fn.glob(project_root .. '/*.csproj'), ':t:r')
  if project_name and project_name ~= '' then
    return project_name .. '.' .. namespace
  end

  return namespace
end

-- Function to get class name from filename
local function get_classname()
  return vim.fn.expand('%:t:r')
end

-- C# class snippet
ls.add_snippets('cs', {
  s('csc', {
    t('namespace '),
    f(function() return get_namespace() end),
    t({ ';', '', 'public class ' }),
    f(function() return get_classname() end),
    t({ '', '{', '\t' }),
    i(0),
    t({ '', '}' }),
  }),
})
