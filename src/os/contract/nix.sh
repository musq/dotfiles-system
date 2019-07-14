#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Nix\n\n"

add_group "nix-users" "system"

add_user_to_group "nix-users" "$(id -un)"

execute \
    "chgrp nix-users /nix/var/nix/daemon-socket \
        && chmod 770 /nix/var/nix/daemon-socket" \
    "Restrict nix daemon-socket to nix-users" \
    "sudo"
