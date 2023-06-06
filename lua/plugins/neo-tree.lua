vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
vim.api.nvim_set_keymap("", "<TAB>", ":Neotree reveal<CR>", {silent = true})
require "window-picker".setup(
  {
    autoselect_one = true,
    include_current = false,
    filter_rules = {
      -- filter using buffer options
      bo = {
        -- if the file type is one of following, the window will be ignored
        filetype = {"neo-tree", "neo-tree-popup", "notify"},
        -- if the buffer type is one of following, the window will be ignored
        buftype = {"terminal", "quickfix"}
      }
    },
    selection_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    other_win_hl_color = "#519aba"
  }
)

require("neo-tree").setup(
  {
    default_component_configs = {
      icon = {
        folder_empty = "󰜌",
        folder_empty_open = "󰜌"
      },
      git_status = {
        symbols = {
          renamed = "󰁕",
          unstaged = "󰄱"
        }
      }
    },
    document_symbols = {
      kinds = {
        File = {icon = "󰈙", hl = "Tag"},
        Namespace = {icon = "󰌗", hl = "Include"},
        Package = {icon = "󰏖", hl = "Label"},
        Class = {icon = "󰌗", hl = "Include"},
        Property = {icon = "󰆧", hl = "@property"},
        Enum = {icon = "󰒻", hl = "@number"},
        Function = {icon = "󰊕", hl = "Function"},
        String = {icon = "󰀬", hl = "String"},
        Number = {icon = "󰎠", hl = "Number"},
        Array = {icon = "󰅪", hl = "Type"},
        Object = {icon = "󰅩", hl = "Type"},
        Key = {icon = "󰌋", hl = ""},
        Struct = {icon = "󰌗", hl = "Type"},
        Operator = {icon = "󰆕", hl = "Operator"},
        TypeParameter = {icon = "󰊄", hl = "Type"},
        StaticMethod = {icon = "󰠄 ", hl = "Function"}
      }
    },
    close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = false,
    sort_case_insensitive = false, -- used when sorting files and directories in the tree
    sort_function = nil, -- use a custom function for sorting files and directories in the tree
    -- sort_function = function (a,b)
    --       if a.type == b.type then
    --           return a.path > b.path
    --       else
    --           return a.type > b.type
    --       end
    --   end , -- this sorts files and directories descendantly
    default_component_configs = {
      container = {
        enable_character_fade = true
      },
      indent = {
        indent_size = 2,
        padding = 1, -- extra padding on left hand side
        -- indent guides
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        highlight = "NeoTreeIndentMarker",
        -- expander config, needed for nesting files
        with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander"
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
        default = "",
        highlight = "NeoTreeFileIcon"
      },
      modified = {
        symbol = "[+]",
        highlight = "NeoTreeGitAdded"
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
        highlight = "NeoTreeFileName"
      },
      git_status = {
        symbols = {
          -- Change type
          added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
          modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
          deleted = "✖",
          -- this can only be used in the git_status source
          renamed = "󰁕",
          -- this can only be used in the git_status source
          -- Status type
          untracked = "",
          ignored = "",
          unstaged = "",
          staged = "",
          conflict = ""
        }
      }
    },
    window = {
      position = "left",
      width = 35,
      mapping_options = {
        noremap = true,
        nowait = true
      },
      mappings = {
        ["<space>"] = {
          "toggle_node",
          nowait = false
        },
        ["<esc>"] = "revert_preview",
        ["P"] = {"toggle_preview", config = {use_float = true}},
        ["s"] = "split_with_window_picker",
        ["v"] = "vsplit_with_window_picker",
        ["t"] = "open_tabnew",
        ["<cr>"] = "open_with_window_picker",
        ["<2-LeftMouse>"] = "open_with_window_picker",
        ["C"] = "close_node",
        ["z"] = "close_all_nodes",
        ["a"] = {
          "add",
          config = {
            show_path = "absolute"
          }
        },
        ["d"] = "delete",
        ["r"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["c"] = "copy",
        ["m"] = {
          "move",
          config = {
            show_path = "absoulte"
          }
        },
        ["q"] = "close_window",
        ["R"] = "refresh",
        ["?"] = "show_help",
        [">"] = "prev_source",
        ["<"] = "next_source"
      }
    },
    nesting_rules = {},
    filesystem = {
      filtered_items = {
        visible = false, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_name = {".git"},
        hide_by_pattern = {},
        always_show = {"node_modules"},
        never_show = {},
        never_show_by_pattern = {}
      },
      follow_current_file = false, -- This will find and focus the file in the active buffer every
      -- time the current file is changed while the tree is open.
      group_empty_dirs = false, -- when true, empty folders will be grouped together
      hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
      -- in whatever position is specified in window.position
      -- "open_current",  -- netrw disabled, opening a directory opens within the
      -- window like netrw would, regardless of window.position
      -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
      use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
      -- instead of relying on nvim autocmd events.
      window = {
        mappings = {
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["H"] = "toggle_hidden",
          ["/"] = "fuzzy_finder",
          ["D"] = "fuzzy_finder_directory",
          ["f"] = "filter_on_submit",
          ["<c-x>"] = "clear_filter",
          ["[g"] = "prev_git_modified",
          ["]g"] = "next_git_modified"
        }
      }
    },
    buffers = {
      follow_current_file = true, -- This will find and focus the file in the active buffer every
      -- time the current file is changed while the tree is open.
      group_empty_dirs = true, -- when true, empty folders will be grouped together
      show_unloaded = true,
      window = {
        mappings = {
          ["d"] = "buffer_delete",
          ["<bs>"] = "navigate_up",
          ["."] = "set_root"
        }
      }
    },
    git_status = {
      window = {
        position = "float",
        mappings = {
          ["gA"] = "git_add_all",
          ["gu"] = "git_unstage_file",
          ["ga"] = "git_add_file",
          ["gr"] = "git_revert_file",
          ["gc"] = "git_commit",
          ["gp"] = "git_push",
          ["gg"] = "git_commit_and_push"
        }
      }
    },
    source_selector = {
      winbar = true,
      statusline = false,
      sources = {
        -- table
        {
          source = "filesystem", -- string
          display_name = " 󰉓 Files" -- string | nil
        },
        {
          source = "buffers", -- string
          display_name = " 󰈙 Buffers" -- string | nil
        },
        {
          source = "git_status", -- string
          display_name = " 󰊢 Git" -- string | nil
        }
      }
    }
  }
)
