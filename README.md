# ALHABIB-NVIM: Ultra-Modern .NET Neovim Configuration

This Neovim configuration is a premium, high-performance IDE setup specifically optimized for **.NET development**. It is crafted by **Al-Habib Ahmed** to provide a seamless, Rider-inspired workflow within Neovim.

> [!IMPORTANT]
> This configuration is tailored for Windows and focuses on the C# / .NET ecosystem using the Roslyn LSP, CSharpier formatter, and netcoredbg.

---

## 🚀 Key Features

- **Roslyn LSP Integration**: Pure C# performance with the latest Roslyn language server.
- **Rider-Inspired Aesthetics**: Tokyonight-night theme customized with authentic JetBrains Rider colors.
- **Smart Formatting**: Automatic formatting via `CSharpier` for C# and `prettier` for web files.
- **Advanced Debugging**: Full integration with `nvim-dap` and `netcoredbg` (F5, F10, F11 workflow).
- **Test Runner**: Integrated .NET test explorer and runner via `neotest-dotnet`.
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

### .NET Development (Debug & Run)
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
| `<leader>dr` | Restart Debugger / Open REPL |
| `<leader>dq` | Stop Debugger |

### Testing (`neotest`)
| Key | Action |
|-----|--------|
| `<leader>nt` | Run nearest test |
| `<leader>nf` | Run current file tests |
| `<leader>ns` | Toggle test summary panel |
| `<leader>no` | Open test output |

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

## 📦 .NET Specific Commands

You can run these commands directly or via the Dashboard:

- **New Solution**: Triggered via Dashboard `n` key.
- **Run Project**: `dotnet run` or use `<C-F5>` for watch mode.
- **Tests**: `dotnet test` or use the `<leader>n` mappings.

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

1. **Neovim 0.10+** (0.11 recommended for latest features).
2. **dotnet SDK** installed and in PATH.
3. **Ghostscript/PowerShell** (for some terminal actions).
4. **Nerd Font** (e.g., JetBrainsMono Nerd Font) for icons.

### Setup
```bash
# Clone the config
git clone https://github.com/alhabib3031/alhabib-nvim-config.git ~/AppData/Local/nvim

# Install Dependencies via Mason (inside Neovim)
:MasonInstall roslyn netcoredbg csharpier xmlformat prettier stylua
```

---

*Made with ❤️ by **Al-Habib Ahmed***
*Deeply integrated for the ultimate C# developer experience.*
