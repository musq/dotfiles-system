#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Build Essentials\n\n"

nix_install "Bash" "nixpkgs.bash_5"
nix_install "Coreutils" "nixpkgs.coreutils-full"
nix_install "GnuPG" "nixpkgs.gnupg" "$@"
nix_install "Less" "nixpkgs.less"
