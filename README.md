# ⚡ sashomarchy

Custom Omarchy & ArchWSL workstation setup with an interactive 3-pane cyberpunk tiling layout, AI CLI integrations, unified themes, and custom right-pane artwork.

---

## 🖥️ Layout Architecture

```text
┌────────────────────────────────────────────────────────┬──────────────────────────────────┐
│  TOP-LEFT (20% height):                                │                                  │
│  📁 yazi Folder Browser                                │  RIGHT SIDE (28% width):         │
│  • Clean 2-column view (parent column hidden)          │  💻 ACTIVE FULL-HEIGHT TERMINAL  │
│  • NOR mode badge removed                              │  • Prompt auto-focused on launch │
├────────────────────────────────────────────────────────┤  • Masked bg3.jpg background     │
│  BOTTOM-LEFT (80% height):                             │    aligned to terminal pane      │
│  📊 btop System Monitor                                │                                  │
│  • Real-time CPU, RAM, GPU, thermals                   │                                  │
│  • Solid #040303 black background                      │                                  │
└────────────────────────────────────────────────────────┴──────────────────────────────────┘
```

---

## 🤖 Integrated AI YOLO Commands

| Command | Alias | Description |
|---|---|---|
| `agy-yolo` | `a`, `ca` | Runs Antigravity with `--dangerously-skip-permissions` |
| `claude-yolo` | `cc` | Runs Claude Code with `--dangerously-skip-permissions` |
| `codex-yolo` | `cx`, `cy` | Runs Codex CLI with `--yolo` |

---

## 🎨 Themes & Customizations

* **CpUnk**: Cyberpunk theme with `#040303` base, `#F82A2A` red accent, and `#FEF348` yellow highlights.
* **Bardo**: Tantrik aesthetic theme.
* **Wallpapers**: Custom right-pane masked portrait artworks stored in `wallpapers/`.

---

## 🔄 Windows Terminal Wallpaper Rotation

`scripts/rotate-terminal-wallpaper.sh` cycles the "Archy" Windows Terminal profile's
`backgroundImage` through the 4 official Omarchy cpunk theme wallpapers (`Arcyx.png`,
`Bxry2.png`, `Cryox3.png`, `Draxo.png` in `Pictures/sashomarchy`). It's called from
`config/bash/.bashrc` in the background on every new interactive shell, so each new
terminal you open gets the next wallpaper in the cycle. State (which wallpaper is
current) is kept in `~/.local/state/sashomarchy/terminal-wallpaper-current`.

Run it manually any time with:

```bash
~/sashomarchy/scripts/rotate-terminal-wallpaper.sh
```

## 🚀 1-Click Installation / Restore

To restore all configs on a fresh Arch installation:

```bash
git clone https://github.com/<username>/sashomarchy.git ~/sashomarchy
cd ~/sashomarchy
chmod +x install.sh
./install.sh
```