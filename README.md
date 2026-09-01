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
| `claude-yolo` | `cx` | Runs Claude Code with `--dangerously-skip-permissions` |
| `codex-yolo` | `cy` | Runs Codex CLI with `--yolo` |
| `agy-yolo` | `ca` | Runs Antigravity with `--dangerously-skip-permissions` |

---

## 🎨 Themes & Customizations

* **CpUnk**: Cyberpunk theme with `#040303` base, `#F82A2A` red accent, and `#FEF348` yellow highlights.
* **Bardo**: Tantrik aesthetic theme.
* **Wallpapers**: Custom right-pane masked portrait artworks stored in `wallpapers/`.

---

## 🚀 1-Click Installation / Restore

To restore all configs on a fresh Arch installation:

```bash
git clone https://github.com/<username>/sashomarchy.git ~/sashomarchy
cd ~/sashomarchy
chmod +x install.sh
./install.sh
```