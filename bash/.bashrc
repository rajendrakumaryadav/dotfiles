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

. "$HOME/.cargo/env"
export PATH=${PATH}:${HOME}/.local/software/zig
export PATH=${PATH}:${HOME}/.local/software/node/bin
export PATH=${PATH}:${HOME}/.local/software/golang/bin

eval "$(starship init bash)"

complete -C /usr/bin/terraform terraform

export PATH=/home/rajendrayadav/.opencode/bin:$PATH
