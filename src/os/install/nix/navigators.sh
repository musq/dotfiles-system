#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Navigators\n\n"

nix_install "exa" "nixpkgs.exa" "$@"
nix_install "fd" "nixpkgs.fd" "$@"
nix_install "fzf" "nixpkgs.fzf" "$@"
nix_install "rg" "nixpkgs.ripgrep" "$@"
nix_install "Tree" "nixpkgs.tree" "$@"
