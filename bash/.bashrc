# .bashrc

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

alias open="xdg-open"
alias ls="exa -l"

# pick - skim-powered fuzzy finder / mac-style file picker
alias p='pick'
alias pf='pick file'
alias pg='pick grep'
alias pd='pick dir'
alias pr='pick recent'
alias pgs='pick git'

# --- zellij ----------------------------------------------------------------
# Common shortcuts (work whether or not auto-start has dropped us in)
if command -v zellij >/dev/null 2>&1; then
    alias  z='zellij'
    alias zj='zellij'
    alias za='zellij attach'      # za [name] - attach / create named session
    alias zls='zellij list-sessions'
    alias zk='zellij kill-session' # zk [name]
    alias zka='zellij kill-all-sessions'   # panic button
    alias zm='zellij delete-session'       # delete a single session
fi

# --- Auto-start zellij on terminal open -----------------------------------
# Drop straight into a zellij session the first time a new terminal opens.
# Skipped when:
#   * ZELLIJ_AUTO=0 in the environment (opt-out)
#   * ZELLIJ is already set (we are inside a zellij pane)
#   * TMUX is set (we are inside tmux)
#   * The shell is not interactive (no PS1) or has no TTY
#   * zellij is not on PATH
if [ "${ZELLIJ_AUTO:-1}" = "1" ] \
   && [ -z "${ZELLIJ:-}" ] \
   && [ -z "${TMUX:-}" ] \
   && [ -n "${PS1:-}" ] \
   && [ -t 0 ] && [ -t 1 ] \
   && command -v zellij >/dev/null 2>&1; then
    exec zellij
fi

. "$HOME/.cargo/env"
export PATH=${PATH}:${HOME}/.local/software/zig
export PATH=${PATH}:${HOME}/.local/software/node/bin
export PATH=${PATH}:${HOME}/.local/software/golang/bin

eval "$(starship init bash)"

complete -C /usr/bin/terraform terraform

export PATH=/home/rajendrayadav/.opencode/bin:$PATH
