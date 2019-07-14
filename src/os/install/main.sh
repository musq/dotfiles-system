#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n ● Installs\n"


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

OS="$(get_os)"

if [ ! -e "$OS/main.sh" ]; then
    print_error "Unidentified OS - Ignoring package install"
fi

./"$OS"/main.sh

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if ! cmd_exists "nix" "sudo"; then
    sh <(curl https://nixos.org/nix/install) --daemon
fi

if cmd_exists "nix" "sudo"; then
    ./nix/main.sh "$@"
fi
