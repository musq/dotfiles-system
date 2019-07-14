#!/bin/bash

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
install_package "rsync" "rsync"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# https://github.com/NixOS/nix/issues/2633
# https://github.com/NixOS/nix/issues/2636
execute \
    "sudo sysctl -w kernel.unprivileged_userns_clone=1" \
    "Set unprivileged userns clone in Kernel"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Cleanup

autoremove
