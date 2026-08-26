# Neovim Configuration

Personal Neovim configuration built with [lazy.nvim](https://github.com/folke/lazy.nvim) for modern plugin management.

## Requirements

### Core

| Tool | Why |
| --- | --- |
| Neovim >= 0.11 | Uses `vim.lsp.config`/`vim.lsp.enable`, `vim.diagnostic.jump`, `vim.o.winborder` |
| git, curl, unzip | lazy.nvim bootstrap, Mason downloads |
| gcc + make | Building `telescope-fzf-native` and tree-sitter parsers |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Telescope live grep / grep string |
| [fd](https://github.com/sharkdp/fd) | Faster Telescope file finding |
| [xclip](https://github.com/astrand/xclip) | Clipboard provider — hard-coded in `init.lua` (X11; use `wl-clipboard` on Wayland and adjust `vim.g.clipboard`) |
| [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter) | Required system-wide by `tree-sitter-manager.nvim` to compile parsers |
| Rust / cargo | `blink.cmp` builds its fuzzy matcher with `cargo build --release` |
| A [Nerd Font](https://www.nerdfonts.com/) | Icons in Heirline, Neo-tree, Telescope, blink |

### Language toolchains

Mason installs the language servers themselves, but several need a runtime present:

| Toolchain | Needed for |
| --- | --- |
| Node.js + npm | vtsls, eslint, tailwindcss, html/css/json/yaml LS, intelephense, prismals, bashls, cspell, prettierd |
| .NET SDK | roslyn, fsautocomplete, csharpier |
| Go | gopls |
| Rust (rustup) | rust_analyzer |
| Zig | zls |
| PHP | intelephense, php-cs-fixer |
| Python | some Mason packages |

### Formatters not managed by Mason

- `oxfmt` — JS/TS/CSS formatting (`npm i -g oxfmt`, or provide it per project)
- `csharpierd` — C# formatting daemon (`dotnet tool install -g csharpier`, or `bun i -g csharpierd`)

`stylua`, `prettierd`, `php-cs-fixer` and `cspell` are auto-installed by mason-tool-installer.

### Optional

- [Bun](https://bun.sh) — for the `neotest-bun` adapter
- Jest in the project (`./node_modules/.bin/jest`) — for the `neotest-jest` adapter
- [kitty](https://sw.kovidgoyal.net/kitty/) — the `kitty/` directory holds a matching terminal config

## Installing on Arch Linux

```bash
# Core
sudo pacman -S --needed \
  neovim git curl wget unzip base-devel gcc make cmake \
  ripgrep fd xclip wl-clipboard tree-sitter-cli

# Language toolchains for the configured LSP servers
sudo pacman -S --needed \
  nodejs npm rustup go dotnet-sdk php python python-pip zig

rustup default stable   # blink.cmp needs a working cargo

# Nerd Font (any patched font works; these match kitty/kitty.conf)
sudo pacman -S --needed ttf-nerd-fonts-symbols-mono ttf-hack-nerd

# Terminal config in kitty/ (optional)
sudo pacman -S --needed kitty
```

From the AUR (via `yay`):

```bash
# Neovim nightly, if you want it ahead of the repo version
yay -S neovim-nightly-bin

# The font referenced by kitty/kitty.conf
yay -S ttf-input
```

Formatters that Mason does not handle:

```bash
npm i -g oxfmt
dotnet tool install -g csharpier   # provides csharpierd
```

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
