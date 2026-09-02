# Ensure npm global, local bins, and standard paths are in PATH
export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$PATH"

# History configuration
HISTCONTROL=ignoreboth
shopt -s histappend checkwinsize
HISTSIZE=5000
HISTFILESIZE=10000

# NVM (Node Version Manager) integration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
source "$OMARCHY_PATH/default/bash/rc"

# VS Code terminal integration
[[ "$TERM_PROGRAM" == "vscode" ]] && . "/mnt/c/Users/Bastani/AppData/Local/Programs/Microsoft VS Code/resources/app/out/vs/workbench/contrib/terminal/common/scripts/shellIntegration-bash.sh" 2>/dev/null

# Default to Linux home directory if opened in Windows user directory
if [[ "$PWD" == "/mnt/c/Users/"* ]]; then
  cd ~
fi

# AI Assistant Shortcuts
alias agy-yolo='agy --dangerously-skip-permissions'
alias claude-yolo='claude --dangerously-skip-permissions'
alias codex-yolo='codex --yolo'
alias a='agy --dangerously-skip-permissions'
alias c='claude --dangerously-skip-permissions'
alias x='codex --yolo'
alias ca='agy --dangerously-skip-permissions'
alias cc='claude --dangerously-skip-permissions'
alias cx='codex --yolo'
alias cy='codex --yolo'

# Fast fzf file/dir search with fd
if command -v fd >/dev/null 2>&1; then
    _fd_excludes=(--exclude .git --exclude node_modules --exclude dist --exclude build --exclude .next --exclude .turbo)
    export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow ${_fd_excludes[*]}"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type d --hidden --follow ${_fd_excludes[*]}"
    unset _fd_excludes
fi

# Workflow & Agent Fleet Helpers
alias gstat='~/.tmux/git-radar.sh'
alias proj='~/.tmux/proj-switch.sh'
alias fleet='~/.tmux/toggle-broadcast.sh'
alias tile='~/.tmux/tile-windows.sh'
alias untile='~/.tmux/untile-windows.sh'
# Omarchy's aliases file sets `alias g='git'`, and bash expands aliases before
# it looks up functions — so without this the launchpad below is unreachable.
unalias g 2>/dev/null
g() { exec ~/.tmux/launchpad.sh; }

# Music player (see ~/.tmux/music/)
alias music='~/.tmux/music/browse.sh'
alias mctl='~/.tmux/music/mctl.sh'

# Rotate the Windows Terminal wallpaper on every new terminal. Backgrounded
# and silenced so a slow/failed /mnt/c write never delays or breaks shell
# startup. Must run before the tmux auto-start block below, since that block
# ends in `exec`, which replaces this shell and skips everything after it.
if [[ -t 1 ]]; then
  ( ~/sashomarchy/scripts/rotate-terminal-wallpaper.sh >/dev/null 2>&1 & )
fi

# ── Auto-start a FRESH independent tmux session ──────────────────────────────
# This stays LAST in the file. It ends in `exec tmux attach`, which replaces
# this shell, so anything placed below it never runs in the outer shell.
if [[ -t 1 && -z "$TMUX" && -z "$INSIDE_EMACS" && -z "$EMACS" && -z "$VIM" && -z "$NVIM" ]]; then
  SESSION_NAME="Session-$$"

  # Panes are addressed by ID (%N), never by index: tmux renumbers indices on
  # every split, so index-based targets quietly aim at the wrong pane once the
  # layout grows past two.
  # -x/-y are essential: a detached session is created at tmux's default
  # 80x24 regardless of the real terminal, so every height computed from it
  # would be wrong and the layout would silently fall back to two panes.
  _dev_cols=$(tput cols 2>/dev/null); _dev_lines=$(tput lines 2>/dev/null)
  [[ "$_dev_cols"  =~ ^[0-9]+$ ]] || _dev_cols=209
  [[ "$_dev_lines" =~ ^[0-9]+$ ]] || _dev_lines=51
  _dev_main=$(tmux new-session -d -s "$SESSION_NAME" -n 'Dev' \
                -x "$_dev_cols" -y "$_dev_lines" -P -F '#{pane_id}')
  _dev_right=$(tmux split-window -h -t "$_dev_main" -l 50% -P -F '#{pane_id}')

  _dev_h=$(tmux display-message -p -t "$_dev_main" '#{window_height}')
  [[ "$_dev_h" =~ ^[0-9]+$ ]] || _dev_h=50

  if (( _dev_h >= 36 )); then
    # Left column, top to bottom: yazi | cockpit | now-playing 6 | cava 9.
    # Each split gives the NEW pane -l rows and leaves the original with
    # (old - l - 1), the extra row being the border.
    #
    # The music block is fixed: nowplaying.sh draws exactly six rows, and the
    # visualiser gets what is left over after the cockpit has been fed. The
    # cockpit is the pane that rewards height — every extra row is another
    # repo or process it can show — so it wins the trade against a spectrum
    # that still reads fine at six. yazi absorbs the rest, up to the 20 rows
    # it wants, which keeps the cockpit above its floor on a short terminal.
    _dev_viz=6
    _dev_music=$(( 6 + _dev_viz + 1 ))
    _dev_yazi=$(( _dev_h - _dev_music - 9 - 3 ))
    (( _dev_yazi > 20 )) && _dev_yazi=20
    _dev_btop=$(tmux split-window -v -t "$_dev_main" -l $(( _dev_h - _dev_yazi - 1 )) -P -F '#{pane_id}')
    _dev_np=$(tmux   split-window -v -t "$_dev_btop" -l "$_dev_music" -P -F '#{pane_id}')
    _dev_cava=$(tmux split-window -v -t "$_dev_np"   -l "$_dev_viz" -P -F '#{pane_id}')
    # The mouse transport bindings in tmux.conf key off this, so clicks are
    # only intercepted here and every other pane keeps stock behaviour.
    tmux set -p -t "$_dev_np" @music 1
    tmux send-keys -t "$_dev_np"   '~/.tmux/music/nowplaying.sh' C-m
    tmux send-keys -t "$_dev_cava" '~/.tmux/music/cava-run.sh' C-m
  else
    # Too short for a music row — fall back to the classic two-pane column.
    _dev_btop=$(tmux split-window -v -t "$_dev_main" -l 55% -P -F '#{pane_id}')
  fi

  tmux send-keys -t "$_dev_main"  'yazi' C-m
  tmux send-keys -t "$_dev_btop"  '~/.tmux/cockpit.sh' C-m
  tmux send-keys -t "$_dev_right" 'clear; fastfetch; claude --dangerously-skip-permissions' C-m
  tmux select-pane -t "$_dev_right"

  unset _dev_main _dev_right _dev_btop _dev_np _dev_cava _dev_h _dev_cols _dev_lines
  unset _dev_music _dev_yazi _dev_viz
  exec tmux attach-session -t "$SESSION_NAME"
fi
