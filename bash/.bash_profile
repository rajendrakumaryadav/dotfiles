# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
. "$HOME/.cargo/env"

if [ -e /home/rajendrayadav/.nix-profile/etc/profile.d/nix.sh ]; then . /home/rajendrayadav/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# Added by `rbenv init` on Saturday 14 February 2026 03:09:10 PM IST
eval "$(~/.rbenv/bin/rbenv init - --no-rehash bash)"
