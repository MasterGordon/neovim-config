call plug#begin()
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'
Plug 'junegunn/goyo.vim'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'tpope/vim-commentary'
Plug 'mhinz/vim-signify'
Plug 'neovim/nvim-lspconfig'
Plug 'mhartington/formatter.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'onsails/lspkind-nvim'
Plug 'MasterGordon/monokai.nvim'
Plug 'ron89/thesaurus_query.vim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'blackcauldron7/surround.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'SidOfc/mkdx'
Plug 'nacro90/numb.nvim'
Plug 'glepnir/dashboard-nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'davidgranstrom/nvim-markdown-preview'
Plug 'RishabhRD/popfix'
Plug 'RishabhRD/nvim-lsputils'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'folke/todo-comments.nvim'
Plug 'windwp/nvim-ts-autotag'
Plug 'jiangmiao/auto-pairs'
Plug 'simrat39/symbols-outline.nvim'
Plug 'ray-x/lsp_signature.nvim'

" post install (yarn install | npm install) then load plugin only for editing supported files
call plug#end()

nmap <leader>f <CMD>Telescope find_files<CR>

lua require('numb').setup()

" Theme
colorscheme monokai

" StatusLine
luafile $HOME/.config/nvim/plugins/galaxyline.lua

" Lsp Signature
" lua require'lsp_signature'.on_attach()

" Dashboard
let g:dashboard_default_executive ='telescope'
nnoremap <silent> <Leader>r :DashboardFindHistory<CR>

" Startify
let g:startify_custom_header = startify#pad(split(system('cat $HOME/.config/nvim/splash'), '\n'))
lua << EOF
function _G.webDevIcons(path)
  local filename = vim.fn.fnamemodify(path, ':t')
  local extension = vim.fn.fnamemodify(path, ':e')
  return require'nvim-web-devicons'.get_icon(filename, extension, { default = true })
end
EOF

function! StartifyEntryFormat() abort
  return 'v:lua.webDevIcons(absolute_path) . " " . entry_path'
endfunction

" commentstring
lua << EOF
require'nvim-treesitter.configs'.setup {
  context_commentstring = {
    enable = true
  }
}
EOF

" Outline
noremap <silent> <leader>o :SymbolsOutline<CR>

" Bufferline
lua <<EOF
diagnostics_indicator = function(count, level, diagnostics_dict, context)
  local s = " "
  for e, n in pairs(diagnostics_dict) do
    local sym = e == "error" and " "
      or (e == "warning" and " " or "" )
    s = s .. n .. sym
  end
  return s
end
require'bufferline'.setup{
options = {
    always_show_bufferline = true,
    diagnostics_indicator = diagnostics_indicator,
    diagnostics = "nvim_lsp",
    separator_style = "thin"
  }
}
EOF
noremap <silent> <A-1> :lua require"bufferline".go_to_buffer(1)<CR>
noremap <silent> <A-2> :lua require"bufferline".go_to_buffer(2)<CR>
noremap <silent> <A-3> :lua require"bufferline".go_to_buffer(3)<CR>
noremap <silent> <A-4> :lua require"bufferline".go_to_buffer(4)<CR>
noremap <silent> <A-5> :lua require"bufferline".go_to_buffer(5)<CR>
noremap <silent> <A-6> :lua require"bufferline".go_to_buffer(6)<CR>
noremap <silent> <A-7> :lua require"bufferline".go_to_buffer(7)<CR>
noremap <silent> <A-8> :lua require"bufferline".go_to_buffer(8)<CR>
noremap <silent> <A-9> :lua require"bufferline".go_to_buffer(9)<CR>
noremap <silent> <A-0> :lua require"bufferline".go_to_buffer(10)<CR>
noremap <A-Left> <C-w><Left>
noremap <A-Up> <C-w><Up>
noremap <A-Down> <C-w><Down>
noremap <A-Right> <C-w><Right>

" colorizer
lua <<EOF
require 'colorizer'.setup {
  '*'; -- Highlight all files, but customize some others.
}
EOF

" Prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile
map <leader>p :Prettier<CR>

" Surround
lua require"surround".setup{}

" NVim Tree Config
let g:nvim_tree_auto_close = 1
let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ]
let g:nvim_tree_indent_markers = 1
map <TAB> :NvimTreeFindFile<CR>

let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★"
    \   },
    \ 'folder': {
    \   'default': "",
    \   'open': "",
    \   'symlink': "",
    \   }
    \ }

lua <<EOF
    local tree_cb = require'nvim-tree.config'.nvim_tree_callback
    vim.g.nvim_tree_bindings = {
      -- default mappings
      ["<CR>"]           = tree_cb("edit"),
      ["<2-LeftMouse>"]  = tree_cb("edit"),
      ["<2-RightMouse>"] = tree_cb("cd"),
      ["<C-]>"]          = tree_cb("cd"),
      ["s"]          = tree_cb("vsplit"),
      ["i"]          = tree_cb("split"),
      ["t"]          = tree_cb("tabnew"),
      ["<"]              = tree_cb("prev_sibling"),
      [">"]              = tree_cb("next_sibling"),
      ["<BS>"]           = tree_cb("close_node"),
      ["<S-CR>"]         = tree_cb("close_node"),
      ["<Tab>"]          = tree_cb("preview"),
      ["I"]              = tree_cb("toggle_ignored"),
      ["I"]              = tree_cb("toggle_dotfiles"),
      ["r"]              = tree_cb("refresh"),
      ["c"]              = tree_cb("create"),
      ["d"]              = tree_cb("remove"),
      ["m"]              = tree_cb("rename"),
      ["<C-r>"]          = tree_cb("full_rename"),
      ["x"]              = tree_cb("cut"),
      ["c"]              = tree_cb("copy"),
      ["p"]              = tree_cb("paste"),
      ["[c"]             = tree_cb("prev_git_item"),
      ["]c"]             = tree_cb("next_git_item"),
      ["-"]              = tree_cb("dir_up"),
      ["q"]              = tree_cb("close"),
    }
EOF

" TreeSitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  indent = {
    enable = true
  },
}
EOF

" Closetag
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.mako,*.jsx,*.tsx'

" TS-Autotag
luafile $HOME/.config/nvim/plugins/autotag.lua
" Thesaurus
nnoremap <Leader>s :ThesaurusQueryReplaceCurrentWord<CR>
let g:tq_language=['en', 'de']
let g:tq_enabled_backends=["openthesaurus_de", "woxikon_de", "openoffice_en", "datamuse_com"]

" Tagalong
let g:tagalong_verbose = 1
let g:tagalong_filetypes = ['html', 'xml', 'jsx', 'tsx', 'eruby', 'ejs', 'eco', 'php', 'htmldjango', 'javascriptreact', 'typescriptreact', 'typescript.tsx', 'javascript.jsx', 'mako']
let g:tagalong_additional_filetypes = ['typescript.tsx', 'javascript.jsx', 'mako']

" coc.nvim
" source plugins/coc.vim

" nvim-lsp
luafile $HOME/.config/nvim/plugins/lsp.lua

" Formatter
luafile $HOME/.config/nvim/plugins/formatter.lua

" nvim.compe
luafile $HOME/.config/nvim/plugins/compe.lua
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" lspkind
lua <<EOF
require('lspkind').init({
    -- with_text = true,
    -- symbol_map = {
    --   Text = '',
    --   Method = 'ƒ',
    --   Function = '',
    --   Constructor = '',
    --   Variable = '',
    --   Class = '',
    --   Interface = 'ﰮ',
    --   Module = '',
    --   Property = '',
    --   Unit = '',
    --   Value = '',
    --   Enum = '了',
    --   Keyword = '',
    --   Snippet = '﬌',
    --   Color = '',
    --   File = '',
    --   Folder = '',
    --   EnumMember = '',
    --   Constant = '',
    --   Struct = ''
    -- },
})
EOF

" vim-signify

let g:signify_sign_add    = '│'
let g:signify_sign_change = '│'

" todo-comments
lua << EOF
require("todo-comments").setup (
{
  signs = true, -- show icons in the signs column
  sign_priority = 20, -- sign priority
  -- keywords recognized as todo comments
  keywords = {
    FIX = {
      icon = " ", -- icon used for the sign, and in search results
      color = "error", -- can be a hex color, or a named color (see below)
      alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
      -- signs = false, -- configure signs for some keywords individually
    },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
  },
  merge_keywords = true, -- when true, custom keywords will be merged with the defaults
  -- highlighting of the line containing the todo comment
  -- * before: highlights before the keyword (typically comment characters)
  -- * keyword: highlights of the keyword
  -- * after: highlights after the keyword (todo text)
  highlight = {
    before = "", -- "fg" or "bg" or empty
    keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
    after = "fg", -- "fg" or "bg" or empty
    pattern = [[.*<(KEYWORDS)\s*:]], -- pattern used for highlightng (vim regex)
    comments_only = true, -- uses treesitter to match keywords in comments only
    max_line_len = 400, -- ignore lines longer than this
  },
  -- list of named colors where we try to extract the guifg from the
  -- list of hilight groups or use the hex color if hl not found as a fallback
  colors = {
    error = { "LspDiagnosticsDefaultError", "ErrorMsg", "#DC2626" },
    warning = { "LspDiagnosticsDefaultWarning", "WarningMsg", "#FBBF24" },
    info = { "LspDiagnosticsDefaultInformation", "#2563EB" },
    hint = { "LspDiagnosticsDefaultHint", "#10B981" },
    default = { "Identifier", "#7C3AED" },
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    -- regex that will be used to match keywords.
    -- don't replace the (KEYWORDS) placeholder
    pattern = [[\b(KEYWORDS):]], -- ripgrep regex
    -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
  },
}
)
EOF
