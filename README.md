# ALHABIB-NVIM: Ultra-Modern .NET Neovim Configuration

This Neovim configuration is a premium, high-performance IDE setup specifically optimized for **.NET development**. It is crafted by **Al-Habib Ahmed** to provide a seamless, Rider-inspired workflow within Neovim.

> [!IMPORTANT]
> This configuration is tailored for Windows and focuses on the C# / .NET ecosystem using **[easy-dotnet.nvim](https://github.com/GustavEikaas/easy-dotnet.nvim)** which ships with built-in Roslyn LSP, netcoredbg debugger, test runner, NuGet management, and more — all in one plugin.

---

## 🚀 Key Features

- **easy-dotnet.nvim**: All-in-one .NET plugin — Roslyn LSP, netcoredbg, test runner, NuGet, EF Core, User Secrets, Workspace Diagnostics.
- **Rider-Inspired Aesthetics**: Tokyonight-night theme customized with authentic JetBrains Rider colors.
- **Smart Formatting**: Automatic formatting via `CSharpier` for C# and `prettier` for web files.
- **Advanced Debugging**: Full integration with `nvim-dap` and `netcoredbg` (F5, F10, F11 workflow).
- **Premium Dashboard**: A custom-built dashboard for quick project switching and .NET actions.
- **Smooth Animations**: Moving cursor with animations via `SmoothCursor.nvim`.
- **Zen Mode**: Distraction-free coding with `centerpad`.
- **Git Support**: Visual conflict resolution and deep Telescope integration.

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
| `nn` | Null check with ArgumentNullException |
| `di` | Dependency Injection field (`private readonly...`) |
| `asyncm` | Async Task method template |
| `cw` | `Console.WriteLine()` |
| `/// summary` | XML Documentation Summary |

---

## 🛠️ Requirements & Installation

1. **Neovim 0.10+** (0.11 recommended).
2. **dotnet SDK** installed and in PATH.
3. **EasyDotnet server**: `dotnet tool install -g EasyDotnet`
4. **Nerd Font** (e.g., JetBrainsMono Nerd Font) for icons.

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
