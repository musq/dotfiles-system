#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Debian\n\n"


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

update
upgrade

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_package "bzip2" "bzip2"
install_package "python3-venv" "python3-venv"
install_package "rsync" "rsync"
install_package "xz-utils" "xz-utils"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# https://github.com/NixOS/nix/issues/2633
# https://github.com/NixOS/nix/issues/2636
execute \
    "sudo sysctl -w kernel.unprivileged_userns_clone=1" \
    "Set unprivileged userns clone in Kernel"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

autoremove
