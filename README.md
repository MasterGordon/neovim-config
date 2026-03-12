# Neovim Configuration

Personal Neovim configuration built with [lazy.nvim](https://github.com/folke/lazy.nvim) for modern plugin management.

## Requirements

- Neovim >= 0.10
- [Nerd Font](https://www.nerdfonts.com/) (for icons)
- [xclip](https://github.com/astrand/xclip) (for clipboard support on Linux)
- [ripgrep](https://github.com/BurntSushi/ripgrep) (for Telescope live grep)
- [make](https://www.gnu.org/software/make/) (for building Telescope fzf-native)

## Installation

1. Backup your existing Neovim configuration if you have one
2. Clone this repository to your Neovim config directory:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```
3. Start Neovim - lazy.nvim will automatically bootstrap and install all plugins:
   ```bash
   nvim
   ```

## Features

- **LSP Support**: Pre-configured language servers for TypeScript, Lua, Go, Rust, C#, PHP, and more
- **Auto-formatting**: Format-on-save with conform.nvim
- **Testing**: Integrated test runner with neotest (Jest and Bun support)
- **Fuzzy Finding**: Telescope for files, grep, LSP symbols, and more
- **Syntax Highlighting**: Tree-sitter based highlighting
- **Git Integration**: Gitsigns for inline git blame and hunks
- **Completions**: Blink.cmp for fast autocompletion
- **File Explorer**: Neo-tree for file navigation
- **Status Line**: Custom Heirline configuration

## Key Bindings

Leader key: `Space`

### File Navigation
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Browse buffers

### LSP
- `gd` - Go to definition
- `gr` - Find references
- `<F2>` - Rename symbol
- `<leader>a` - Code actions
- `<leader>d` - Show diagnostics

### Testing
- `<leader>tt` - Run nearest test
- `<leader>tf` - Run tests in current file
- `<leader>td` - Display test output

### Formatting
- `<leader>f` - Format buffer (also auto-formats on save)

### Other
- `<leader><CR>` - Open terminal
- `<leader>n` - Insert C# namespace (C# files only)

## Structure

```
.
├── init.lua                 # Entry point
├── lua/
│   ├── keybinds.lua        # Global keybindings
│   ├── diagnostic.lua      # Diagnostic configuration
│   ├── snippets.lua        # Custom snippets
│   └── plugins/            # Plugin configurations
│       ├── lsp.lua
│       ├── telescope.lua
│       ├── conform.lua
│       ├── neotest.lua
│       └── ...
└── CLAUDE.md               # AI assistant context
```

## Customization

- Edit plugin configurations in `lua/plugins/`
- Add new plugins to the `require('lazy').setup()` call in `init.lua`
- Modify keybindings in `lua/keybinds.lua` or plugin-specific files
- LSP servers and formatters are managed in `lua/plugins/lsp.lua` and `lua/plugins/conform.lua`
