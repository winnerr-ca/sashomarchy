# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
source "$OMARCHY_PATH/default/bash/rc"

# Default to Linux home directory if opened in Windows user directory
if [[ "$PWD" == "/mnt/c/Users/SB"* ]]; then
  cd ~
fi

# AI Assistant Shortcuts
alias agy-yolo='agy --dangerously-skip-permissions'
alias claude-yolo='claude --dangerously-skip-permissions'
alias codex-yolo='codex --yolo'
alias cx='claude --dangerously-skip-permissions'
alias cy='codex --yolo'
alias ca='agy --dangerously-skip-permissions'

# Auto-start a FRESH independent Tmux session
if [[ -z "$TMUX" && -z "$INSIDE_EMACS" && -z "$EMACS" && -z "$VIM" && -z "$NVIM" ]]; then
  SESSION_NAME="Session-$$"

  # Create a brand new independent session
  tmux new-session -d -s "$SESSION_NAME" -n 'Dev'

  # 1. Width Split: Left side 72%, Right terminal 28% (Full Height)
  tmux split-window -h -t "$SESSION_NAME:1" -p 28

  # 2. Height Split Left Side: Top yazi (20%), Bottom btop (80%)
  tmux split-window -v -t "$SESSION_NAME:1.1" -p 80

  # 3. Enforce solid black background on yazi and btop panes in Tmux
  tmux select-pane -t "$SESSION_NAME:1.1" -P 'bg=#040303,fg=#ffffff'
  tmux select-pane -t "$SESSION_NAME:1.2" -P 'bg=#040303,fg=#ffffff'

  # 4. Launch tools in Left panes
  tmux send-keys -t "$SESSION_NAME:1.1" 'yazi' C-m
  tmux send-keys -t "$SESSION_NAME:1.2" 'btop' C-m

  # 5. Flush and focus on the Right terminal for immediate typing
  tmux send-keys -t "$SESSION_NAME:1.3" 'clear' C-m
  tmux select-pane -t "$SESSION_NAME:1.3"

  # Connect to this fresh session
  exec tmux attach-session -t "$SESSION_NAME"
fi