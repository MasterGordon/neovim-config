# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration built on lazy.nvim with a focus on LSP, testing, and modern plugin management. The configuration emphasizes a clean, modular structure with separate plugin files.

## Architecture

### Core Structure
- **init.lua**: Entry point that sets up vim options, loads lazy.nvim, and initializes core modules
- **lua/keybinds.lua**: Global keybindings (ALT navigation, terminal toggle, C# namespace helper)
- **lua/diagnostic.lua**: Diagnostic display configuration with custom signs and virtual text
- **lua/snippets.lua**: LuaSnip snippets (currently contains C# namespace/class generation)
- **lua/plugins/**: Modular plugin configurations, each file returns a lazy.nvim plugin spec

### Plugin Architecture Pattern
Each plugin file follows lazy.nvim's structure:
```lua
return {
  'author/plugin-name',
  dependencies = { ... },
  opts = { ... },
  config = function() ... end,
}
```

## Key Plugins & Configuration

### LSP (lua/plugins/lsp.lua)
- Uses mason.nvim with custom registry including Crashdummyy's registry
- Configured servers: lua_ls, vtsls, jsonls (with schemastore), bashls, zls, cssls, prismals, intelephense, html, yamlls, eslint, tailwindcss, gopls, rust_analyzer, roslyn
- Auto-installs tools: stylua, prettierd, php-cs-fixer, cspell
- Blink.cmp integration for completion capabilities
- Keybindings set on LspAttach:
  - `<leader>a`: Code actions
  - `gd`, `gr`, `gi`: Definition/references/implementation via Telescope
  - `<f2>`: Rename
  - `<leader>d`: Show diagnostics float
  - `<leader>D`: Jump to next diagnostic

### Formatting (lua/plugins/conform.lua)
- Format-on-save enabled (3s timeout)
- Formatters: stylua (Lua), prettierd/prettier (JS/TS/CSS/JSON/Markdown), php-cs-fixer (PHP), gofmt (Go), csharpierd (C#)
- Manual format: `<leader>f`

### Testing (lua/plugins/neotest.lua)
- Adapters: neotest-jest, neotest-bun
- Jest config auto-detection from project root
- Keybindings:
  - `<leader>tt`: Run nearest test
  - `<leader>tf`: Run all tests in current file
  - `<leader>td`: Display test output

### Fuzzy Finding (lua/plugins/telescope.lua)
- Keybindings (all start with `<leader>f`):
  - `ff`: Find files
  - `fg`: Live grep
  - `fb`: Buffers
  - `fd`: Diagnostics
  - `fw`: Grep string under cursor
  - `fh/fk/fs/fr/f.`: Help/keymaps/builtin/resume/oldfiles
  - `ft`: Todo comments

### C# Development
- Roslyn LSP configured
- Custom namespace insertion: `<leader>n` (reads .csproj, constructs namespace from path)
- C# class snippet: `csc` (auto-generates namespace and class from filename)
- csharpierd formatter integration

## Development Workflow

### Testing JavaScript/TypeScript
```bash
# Run nearest test (with cursor on test)
<leader>tt

# Run all tests in file
<leader>tf

# View test output
<leader>td
```

### Formatting
- Auto-formats on save (configured in conform.lua)
- Manual format: `<leader>f`

### LSP Operations
- Jump to definition: `gd` (opens in Telescope)
- Find references: `gr` (opens in Telescope)
- Rename symbol: `<F2>`
- Code actions: `<leader>a`
- Show diagnostics: `<leader>d`
- Next diagnostic: `<leader>D`
- Workspace symbols: `<leader>fs`

## Special Configurations

### Clipboard
Uses xclip for clipboard integration on Linux (configured in init.lua with vim.schedule)

### Theme
TokyoNight theme with transparency disabled on WSL, terminal colors disabled

### Tab Behavior
2-space indentation, tabs converted to spaces globally

### Window Navigation
- ALT + Arrow keys to navigate between splits
- `<C-p>` mapped to `<C-i>` for jump forward

### Terminal
- `<leader><CR>`: Open terminal in insert mode
- `<Esc>`: Exit terminal mode to normal mode

## Plugin Management

### Installing/Updating Plugins
Lazy.nvim auto-bootstraps on first run. To manage plugins:
- Add new plugin specs to lua/plugins/ or directly in init.lua's require('lazy').setup()
- Lazy will auto-install on next startup

### Mason Tool Management
LSP servers and formatters are auto-installed via mason-tool-installer based on the ensure_installed list in lua/plugins/lsp.lua

## Important Notes

- Leader key is Space
- Nerd Font required (vim.g.have_nerd_font = true)
- Swap and backup files disabled
- Relative line numbers enabled
- 10-line scrolloff for cursor positioning
- The configuration uses Neovim 0.10+ APIs with compatibility shim for 0.11 (see client_supports_method in lsp.lua)
