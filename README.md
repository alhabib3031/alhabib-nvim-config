# ALHABIB-NVIM: Ultra-Modern .NET Neovim Configuration

This Neovim configuration is a premium, high-performance IDE setup specifically optimized for **.NET development**. It is crafted by **Al-Habib Ahmed** to provide a seamless, Rider-inspired workflow within Neovim.

> [!IMPORTANT]
> This configuration is tailored for Windows and focuses on the C# / .NET ecosystem using **[easy-dotnet.nvim](https://github.com/GustavEikaas/easy-dotnet.nvim)** which ships with built-in Roslyn LSP, netcoredbg debugger, test runner, NuGet management, and more — all in one plugin.

---

## 🚀 Key Features

- **easy-dotnet.nvim**: All-in-one .NET plugin — Roslyn LSP, netcoredbg, test runner, NuGet, EF Core, User Secrets, Workspace Diagnostics.
- **JetBrains Rider Dark Theme**: Custom tokyonight-based theme using exact Rider Dark colors (`#262626` bg, `#6C95EB` blue, `#C191FF` purple).
- **fzf-lua**: Blazing-fast fullscreen fuzzy finder with exact-match mode, vertical preview, and `Ctrl-q` quickfix send.
- **Comment.nvim**: Smart line/block commenting with Rider-style `<C-k>c` shortcut.
- **LuaSnip**: Snippet engine with VSCode community snippets + custom C# snippets (ctor, prop, di, asyncm, cw).
- **Smart Formatting**: Automatic formatting via `CSharpier` for C# and `prettier` for web files.
- **Advanced Debugging**: Full integration with `nvim-dap` and `netcoredbg` (F5, F10, F11 workflow).
- **Premium Dashboard**: A custom-built dashboard with Rider Dark colors for quick project switching and .NET actions.
- **Smooth Animations**: Moving cursor with animations via `SmoothCursor.nvim`.
- **Zen Mode**: Distraction-free coding with `centerpad`.
- **Git Support**: Visual conflict resolution and deep Telescope/fzf integration.

---

## ⌨️ Keybindings (Rider-Style)

### General & Editor
| Key | Action |
|-----|--------|
| `<leader>pv` | Project View (Explorer) |
| `<C-s>` | Save current file |
| `<C-S-s>` | Save all open files |
| `<C-q>` | Quit Neovim |
| `<C-S-q>` | Quit all windows |
| `<S-l>` / `<S-h>` | Next / Previous Tab (Buffer) |
| `<leader>x` | Close current tab |
| `<Esc>` | Clear search highlights |
| `<leader>z` | Toggle Zen Mode (Centerpad) |

### fzf-lua (Fuzzy Finder)
| Key | Action |
|-----|--------|
| `<leader>sf` | Search Files (fzf, fullscreen) |
| `<leader>sg` | Live Grep (fzf) |
| `<leader>sb` | Search Buffers (fzf) |
| `<leader>sd` | Workspace Diagnostics (fzf) |
| `<leader>sr` | Resume last fzf search |
| `<leader>s.` | Search Recent files (fzf) |
| `<leader>sw` | Search word under cursor (fzf) |
| `<leader>/` | Fuzzy search current buffer |
| `Ctrl-q` *(in fzf)* | Send all results to quickfix |

### Commenting (Comment.nvim)
| Key | Action |
|-----|--------|
| `gcc` | Toggle line comment |
| `gbc` | Toggle block comment |
| `gc` *(visual)* | Toggle line comment on selection |
| `gb` *(visual)* | Toggle block comment on selection |
| `<C-k>c` | Toggle line comment (Rider style) |

### Code Editing & Navigation
| Key | Action |
|-----|--------|
| `J` / `K` (Visual) | Move selected lines down/up |
| `<C-S-d>` | Duplicate line or selection |
| `<C-y>` | Delete line |
| `<leader>p` (Visual) | Paste without losing register |
| `<C-A-l>` / `<leader>f` | **Format Buffer** (CSharpier/LSP) |
| `<leader>rw` | Replace word under cursor |
| `grn` | Rename symbol |
| `gra` | Code Action |
| `grd` | Go to Definition |
| `gri` | Go to Implementation |
| `grr` | Find References |

### .NET Development — easy-dotnet.nvim
| Key | Action |
|-----|--------|
| **`<F5>`** | **Start/Continue Debugging** |
| **`<C-F5>`** | **Dotnet Watch Run (Hot Reload)** |
| `<F10>` | Step Over |
| `<F11>` | Step Into |
| `<S-F11>` | Step Out |
| `<leader>b` | Toggle Breakpoint |
| `<leader>B` | Conditional Breakpoint |
| `<F7>` | Toggle Debugger UI |
| `<leader>dR` | Open DAP REPL |
| `<leader>dq` | Stop Debugger |
| `<leader>dr` | **Dotnet Run** (project picker) |
| `<leader>dw` | **Dotnet Run with Args** |
| `<leader>db` | **Dotnet Build** |
| `<leader>dB` | **Dotnet Build Solution** |
| `<leader>dC` | **Dotnet Clean** |
| `<leader>do` | **Dotnet Restore** |
| `<leader>dN` | **New .NET template** (picker) |
| `<leader>dp` | **Project View** (easy-dotnet panel) |
| `<leader>ds` | **User Secrets** (edit/create/preview) |
| `<leader>dD` | **Workspace Diagnostics** (full solution) |
| `<leader>de` | **EntityFramework** (migrations/db) |
| `<leader>dn` | **NuGet Search** (add packages) |
| `<leader>da` | **Add Package/Reference** |
| `<leader>du` | **Outdated packages** (virtual text) |

### Testing — easy-dotnet.nvim Test Runner
| Key | Action |
|-----|--------|
| `<leader>nt` | Run nearest test |
| `<leader>nf` | Run all tests (solution) |
| `<leader>ns` | Toggle test runner panel |

#### Inside the Test Runner Panel
| Key | Action |
|-----|--------|
| `<leader>r` | Run selected test |
| `<leader>R` | Run all tests |
| `<leader>d` | Debug selected test |
| `<leader>p` | Peek stack trace |
| `<leader>e` | Get build errors |
| `o` | Expand node |
| `E` | Expand all nodes |
| `W` | Collapse all |
| `g` | Go to test file |
| `<C-r>` | Refresh test runner |
| `q` | Close test runner |

### Navigation & Explorer
| Key | Action |
|-----|--------|
| `<leader>e` | Toggle Neo-tree Explorer |
| `\` | Reveal current file in Neo-tree |
| `<A-a>` | Open Oil (Floating file editor) |
| `<C-h/j/k/l>` | Navigate between windows |

### Terminal
| Key | Action |
|-----|--------|
| `<C-\>` | Toggle Floating Terminal |
| `<leader>th` | Open Horizontal Terminal |
| `<leader>tv` | Open Vertical Terminal |
| `<Esc><Esc>` | Exit terminal mode to normal mode |

---

## 🏗️ Architecture

```
lua/
├── options.lua              ← global vim options, folding, diagnostics
├── keymaps.lua              ← all keymaps in one place
└── custom/plugins/
    ├── ui/
    │   ├── theme.lua            ← JetBrains Rider Dark (tokyonight-based)
    │   ├── dashboard.lua        ← startup dashboard with .NET actions
    │   ├── treesitter.lua       ← syntax + folding
    │   ├── ui_tools.lua         ← neo-tree, bufferline, noice, lightbulb
    │   ├── smoothcursor.lua     ← animated cursor
    │   ├── indent_line.lua      ← indent guides
    │   └── mini.lua             ← mini.icons etc.
    └── tools/
        ├── fzf.lua              ← fzf-lua (files, grep, diagnostics, ui.select)
        ├── snippets.lua         ← LuaSnip + C# / Lua snippets
        ├── comments.lua         ← Comment.nvim (gcc, gbc, <C-k>c)
        ├── telescope.lua        ← LSP pickers, help, keymaps
        ├── debugger.lua         ← nvim-dap + dapui (.NET / netcoredbg)
        ├── extras.lua           ← oil.nvim, centerpad, git-conflict, smart-splits
        ├── easy_dotnet.lua      ← .NET all-in-one (run, build, test, NuGet, EF)
        ├── git.lua              ← gitsigns
        ├── autopairs.lua
        ├── lint.lua
        ├── terminal.lua         ← toggleterm
        └── which-key.lua

Fuzzy-finder split:
  fzf-lua  → files, live_grep, buffers, diagnostics, oldfiles, vim.ui.select
  telescope → LSP go-to, references, help_tags, keymaps, commands

easy-dotnet.nvim (single plugin handles):
  ├── Roslyn LSP          ← replaces roslyn.nvim
  ├── netcoredbg debugger ← replaces manual DAP config
  ├── Test Runner         ← replaces neotest-dotnet
  ├── NuGet management
  ├── User Secrets
  ├── Workspace Diagnostics
  └── EF Core migrations
```

---

## 📝 Snippets (C#)

| Prefix | Description |
|--------|-------------|
| `ctor` | Constructor with class name |
| `prop` | Auto-property `public T Prop { get; set; }` |
| `nn` | Null check `ArgumentNullException.ThrowIfNull()` |
| `di` | DI field `private readonly IService _service` |
| `asyncm` | Async Task method template |
| `cw` | `Console.WriteLine()` |
| `/// summary` | XML Documentation Summary |

> Snippets use **Tab** to expand and jump forward, **Shift-Tab** to jump backward.

---

## 🛠️ Requirements & Installation

1. **Neovim 0.10+** (0.11 recommended).
2. **dotnet SDK** installed and in PATH.
3. **EasyDotnet server**: `dotnet tool install -g EasyDotnet`
4. **Nerd Font** (e.g., JetBrainsMono Nerd Font) for icons.
5. **fzf** binary in PATH — required by fzf-lua. Install via:
   - Windows (Scoop): `scoop install fzf`
   - Windows (Winget): `winget install junegunn.fzf`

### Setup
```bash
# Clone the config
git clone https://github.com/alhabib3031/alhabib-nvim-config.git ~/AppData/Local/nvim

# Install the easy-dotnet server (required)
dotnet tool install -g EasyDotnet

# Install formatters via Mason (inside Neovim)
:MasonInstall csharpier xmlformat prettier stylua
```

> [!NOTE]
> `roslyn` and `netcoredbg` are now managed automatically by **easy-dotnet.nvim** — no need to `:MasonInstall` them separately.

---

*Made with ❤️ by **Al-Habib Ahmed***  
*Deeply integrated for the ultimate C# developer experience.*
