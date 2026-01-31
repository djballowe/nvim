# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration based on kickstart.nvim. It uses lazy.nvim as the plugin manager with Lua-only configuration.

## Linting/Formatting

```bash
stylua --check .   # Check Lua formatting (used in CI)
stylua .           # Fix Lua formatting
```

Stylua config in `.stylua.toml`: 160 column width, 2-space indent, Unix line endings.

## Architecture

### Entry Point and Initialization Order

`init.lua` is the main entry point. It loads modules in this order:
1. `require("setup.lazy")` - Plugin manager bootstrap and plugin specs
2. `require("setup.keymaps")` - Core keymaps (leader key is `<space>`)
3. `require("setup.settings")` - Vim options (4-space tabs, line numbers, etc.)

Then `init.lua` continues with inline configuration for:
- Auto-commands (highlight on yank, file change detection)
- Telescope, nvim-tree, Treesitter, LSP, and completion setup

### Plugin Organization

Plugins are specified in two locations:
- `lua/setup/lazy.lua` - Main plugin list with lazy.nvim specs
- `lua/custom/plugins/` - Individual plugin configs (nvim-tree, conform, trouble, undotree, ts-comments)
- `lua/kickstart/plugins/` - Optional kickstart modules (autoformat, debug)

### Key Patterns

**Git root grep** (init.lua:26-59): Custom `find_git_root()` function and `:LiveGrepGitRoot` command for repository-scoped searching.

**LSP configuration** (init.lua:183-294): Servers defined in `servers` table, Mason auto-installs them. Add new LSP servers to this table.

**Formatter configuration** (custom/plugins/conform.lua): File type to formatter mappings. Keymap: `<leader>mp`.

### LSP Servers Currently Configured

- `bashls` - Bash/shell scripts
- `lua_ls` - Lua (with Neovim workspace settings)

To add a new LSP server, add it to the `servers` table in init.lua around line 242.

### Treesitter Languages

Auto-installed: C, C++, Go, Lua, Python, Rust, TSX, JavaScript, TypeScript, Vimdoc, Vim, Bash, Vue, SCSS, JSON, GraphQL, SQL

## Key Commands

- `:Format` - Format buffer with LSP
- `:KickstartFormatToggle` - Toggle autoformat on save
- `:LiveGrepGitRoot` - Grep in git repository root
