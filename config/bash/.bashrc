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
alias ca='agy --dangerously-skip-permissions'
alias cc='claude --dangerously-skip-permissions'
alias cx='codex --yolo'
alias cy='codex --yolo'

# Auto-start a FRESH independent Tmux session
if [[ -t 1 && -z "$TMUX" && -z "$INSIDE_EMACS" && -z "$EMACS" && -z "$VIM" && -z "$NVIM" ]]; then
  SESSION_NAME="Session-$$"

  # Create a brand new independent session
  tmux new-session -d -s "$SESSION_NAME" -n 'Dev'

  # 1. Width Split: Left side 50%, Right terminal 50% (Full Height)
  tmux split-window -h -t "$SESSION_NAME:1.1" -p 50

  # 2. Height Split Left Side: Top yazi (45%), Bottom btop (55%)
  tmux split-window -v -t "$SESSION_NAME:1.1" -p 55

  # 3. Launch tools in Left panes
  tmux send-keys -t "$SESSION_NAME:1.1" 'yazi' C-m
  tmux send-keys -t "$SESSION_NAME:1.2" 'btop' C-m

  # 4. Run fastfetch & launch Antigravity in the Right terminal, focused and ready
  tmux send-keys -t "$SESSION_NAME:1.3" 'clear; fastfetch; agy --dangerously-skip-permissions' C-m
  tmux select-pane -t "$SESSION_NAME:1.3"

  # Connect to this fresh session
  exec tmux attach-session -t "$SESSION_NAME"
fi

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
g() { exec ~/.tmux/launchpad.sh; }