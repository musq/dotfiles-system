#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Miscellaneous Tools\n\n"

nix_install "Duplicati" "nixpkgs.duplicati"
nix_install "htop" "nixpkgs.htop"
nix_install "Icdiff" "nixpkgs.icdiff" "$@"
nix_install "Tmux" "nixpkgs.tmux" "$@"
nix_install "Xclip" "nixpkgs.xclip"
