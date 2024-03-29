-- vim.g.nvim_tree_indent_markers = 1
-- vim.api.nvim_set_keymap("", "<TAB>", ":NvimTreeFindFile<CR>:NvimTreeFocus<CR>", {silent = true})

vim.cmd [[
autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
autocmd BufRead,BufNewFile NvimTree_1 lua vim.diagnostic.disable()
]]

local tree_cb = require "nvim-tree.config".nvim_tree_callback
-- default mappings
require "nvim-tree".setup(
  {
    auto_reload_on_write = true,
    reload_on_bufenter = true,
    git = {
      enable = true,
      ignore = false,
      timeout = 500
    },
    filters = {
      dotfiles = false,
      custom = {
        ".git",
        ".webpack",
        "\\.out",
        ".cache"
      }
    },
    view = {
      mappings = {
        custom_only = true,
        list = {
          {key = {"<CR>", "o", "<2-LeftMouse>"}, cb = tree_cb("edit")},
          {key = {"<2-RightMouse>", "<C-]>"}, cb = tree_cb("cd")},
          {key = "<C-v>", cb = tree_cb("vsplit")},
          {key = "<C-x>", cb = tree_cb("split")},
          {key = "t", cb = tree_cb("tabnew")},
          {key = "<", cb = tree_cb("prev_sibling")},
          {key = ">", cb = tree_cb("next_sibling")},
          {key = "P", cb = tree_cb("parent_node")},
          {key = "<BS>", cb = tree_cb("close_node")},
          {key = "<S-CR>", cb = tree_cb("close_node")},
          {key = "<Tab>", cb = tree_cb("preview")},
          {key = "K", cb = tree_cb("first_sibling")},
          {key = "J", cb = tree_cb("last_sibling")},
          {key = "I", cb = tree_cb("toggle_ignored")},
          {key = "I", cb = tree_cb("toggle_dotfiles")},
          {key = "r", cb = tree_cb("refresh")},
          {key = "a", cb = tree_cb("create")},
          {key = "d", cb = tree_cb("remove")},
          {key = "m", cb = tree_cb("rename")},
          {key = "<C-r>", cb = tree_cb("full_rename")},
          {key = "x", cb = tree_cb("cut")},
          {key = "c", cb = tree_cb("copy")},
          {key = "p", cb = tree_cb("paste")},
          {key = "y", cb = tree_cb("copy_name")},
          {key = "Y", cb = tree_cb("copy_path")},
          {key = "gy", cb = tree_cb("copy_absolute_path")},
          {key = "[c", cb = tree_cb("prev_git_item")},
          {key = "]c", cb = tree_cb("next_git_item")},
          {key = "-", cb = tree_cb("dir_up")},
          {key = "q", cb = tree_cb("close")},
          {key = "?", cb = tree_cb("toggle_help")}
        }
      }
    },
    renderer = {
      indent_markers = {
        enable = true,
        icons = {
          corner = "└",
          edge = "│ ",
          none = "  "
        }
      },
      icons = {
        webdev_colors = true,
        show = {
          folder_arrow = false
        },
        glyphs = {
          default = "",
          symlink = "",
          git = {
            unstaged = "✗",
            staged = "✓",
            unmerged = "",
            renamed = "➜",
            untracked = "★",
            deleted = "",
            ignored = "◌"
          },
          folder = {
            arrow_open = "",
            arrow_closed = "",
            default = "",
            open = "",
            empty = "",
            empty_open = "",
            symlink = "",
            symlink_open = ""
          }
        }
      }
    }
  }
)
