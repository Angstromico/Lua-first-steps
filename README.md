# Lua learning playground

<div align="center">

```text
██╗     ██╗   ██╗ █████╗
██║     ██║   ██║██╔══██╗
██║     ██║   ██║███████║
██║     ██║   ██║██╔══██║
███████╗╚██████╔╝██║  ██║
╚══════╝ ╚═════╝ ╚═╝  ╚═╝
```

</div>

A small repo for learning **Lua** while following the [Game Development with LÖVE 2D and Lua – Full Course](https://www.youtube.com/watch?v=I549C6SmUnk) from freeCodeCamp.

Right now the exercises are plain Lua scripts (`main.lua`). Later in the course you will move to [LÖVE 2D](https://love2d.org/) for game development.

## Why this repo exists

- **Learn Lua** step by step alongside the video course.
- **Skip repetitive typing** — the `watch` scripts re-run your entry file whenever you save a `.lua` file, so you do not have to type `lua main.lua` after every change.

## Prerequisites

Install Lua on your machine:

| Platform    | How to install                                                                                           |
| ----------- | -------------------------------------------------------------------------------------------------------- |
| **Windows** | [Lua for Windows](https://github.com/rjpcomputing/luaforwindows/releases) or `winget install DEVCOM.Lua` |
| **macOS**   | `brew install lua`                                                                                       |
| **Linux**   | `sudo apt install lua5.4` (or your distro’s package)                                                     |

Verify it works:

```bash
lua -v
```

When you reach the LÖVE 2D sections of the course, install LÖVE separately from [love2d.org](https://love2d.org/).

## Project layout

```
.
├── main.lua      # Entry script — start here
├── watch.ps1     # Auto-run on save (Windows / PowerShell)
└── watch.sh      # Auto-run on save (macOS / Linux / Git Bash)
```

## Running your code

### Manual (one shot)

```bash
lua main.lua
```

### Auto-run on save (recommended)

**Windows (PowerShell):**

```powershell
.\watch.ps1
```

**macOS / Linux / Git Bash:**

```bash
chmod +x watch.sh   # first time only
./watch.sh
```

The watcher will:

1. Run `main.lua` once when it starts.
2. Poll every 500 ms for changes to any `.lua` file in this folder (and subfolders).
3. Re-run `main.lua` when a change is detected.
4. Print a timestamp and the exit code each time.

Press **Ctrl+C** to stop.

### Custom entry file or Lua binary

**PowerShell:**

```powershell
.\watch.ps1 -Entry "other.lua" -Lua "lua5.4"
```

**Bash:**

```bash
./watch.sh other.lua lua5.4
```

## Course reference

| Resource              | Link                                                                                 |
| --------------------- | ------------------------------------------------------------------------------------ |
| Full course (YouTube) | [Game Development with LÖVE 2D and Lua](https://www.youtube.com/watch?v=I549C6SmUnk) |
| LÖVE 2D docs          | [love2d.org/wiki](https://love2d.org/wiki/Main_Page)                                 |
| Lua reference         | [lua.org/manual](https://www.lua.org/manual/5.4/)                                    |

## Tips

- Keep one `main.lua` as the entry point the watcher runs; split logic into other `.lua` files and `require` them as the course progresses.
- When you switch to LÖVE 2D, games are usually run with `love .` from the project folder instead of `lua main.lua`. You can adapt the watch scripts later to call `love` instead of `lua` if you want the same auto-reload workflow for games.
