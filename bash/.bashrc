# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

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
    alias z='zellij'
    alias zj='zellij'
    alias za='zellij attach' # za [name] - attach / create named session
    alias zls='zellij list-sessions'
    alias zk='zellij kill-session'       # zk [name]
    alias zka='zellij kill-all-sessions' # panic button
    alias zm='zellij delete-session'     # delete a single session
fi

# --- Auto-start zellij on terminal open -----------------------------------
# Drop straight into a zellij session the first time a new terminal opens.
# Skipped when:
#   * ZELLIJ_AUTO=0 in the environment (opt-out)
#   * ZELLIJ is already set (we are inside a zellij pane)
#   * TMUX is set (we are inside tmux)
#   * The shell is not interactive (no PS1) or has no TY
#   * zellij is not on PATH
# if [ "${ZELLIJ_AUTO:-1}" = "1" ] \
#    && [ -z "${ZELLIJ:-}" ] \
#    && [ -z "${TMUX:-}" ] \
#    && [ -n "${PS1:-}" ] \
#    && [ -t 0 ] && [ -t 1 ] \
#    && command -v zellij >/dev/null 2>&1; then
#     exec zellij
# fi

# opencode
export PATH=/home/rajendrayadav/.opencode/bin:$PATH
. "$HOME/.cargo/env"

# starship
export STARSHIP_CONFIG="${HOME}/.config/starship.toml"

# zellij
export ZELLIJ_CONFIG_FILE=${HOME}/.config/zellij/config.kdl

eval "$(starship init bash)"

if [ -f ~/.bash_secret ]; then
    . ~/.bash_secret

fi

# Rust tools
# ── eza aliases ───────────────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first --git --no-user --time-style=long-iso'
alias la='eza -la --icons --group-directories-first --git --no-user --time-style=long-iso'
alias lt='eza --tree --icons --level=2 --group-directories-first'
alias vim="nvim"
# ll with a blank line separating dirs from files
function lls() {
    eza -l --icons --git --no-user --time-style=long-iso --color=always "$@" |
        awk 'NR==1{print; print ""} NR>1 && /^d/{print} NR>1 && /^d/{d=1} d && NR>1 && !/^d/{print ""; d=0} NR>1 && !/^d/{print}'
}

export PATH=$HOME/.local/bin:$PATH

export GPG_TTY=$(tty)

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ZVM
export ZVM_INSTALL="$HOME/.zvm/self"
export PATH="$PATH:$HOME/.zvm/bin"
export PATH="$PATH:$ZVM_INSTALL/"

# AWS ministack

complete -C "$(which aws_completer)" aws

# ministack setup
export AWS_ENDPOINT_URL=http://localhost:4566
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_DEFAULT_REGION=us-east-1
# Google AWS_ACCESS_KEY_ID
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/jdk-21.0.12-oracle-x64
export PATH=${JAVA_HOME}/bin:${PATH}

# Load Angular CLI autocompletion.
source <(ng completion script)
. "${HOME}/.deno/env"
source ${HOME}/.local/share/bash-completion/completions/deno.bash

# Added by Antigravity CLI installer
export PATH="${HOME}/.local/bin:$PATH"
