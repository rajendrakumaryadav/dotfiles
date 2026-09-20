# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
. "$HOME/.cargo/env"

if [ -e /home/rajendrayadav/.nix-profile/etc/profile.d/nix.sh ]; then . /home/rajendrayadav/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# Added by `rbenv init` on Saturday 14 February 2026 03:09:10 PM IST
. "/home/rajendrayadav/.deno/env"
source /home/rajendrayadav/.local/share/bash-completion/completions/deno.bash


# Added by Antigravity CLI installer
export PATH="/home/rajendrayadav/.local/bin:$PATH"
