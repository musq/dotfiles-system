#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Downloaders\n\n"

nix_install "Bandwhich" "nixpkgs.bandwhich" "$@"
nix_install "cURL" "nixpkgs.curlFull"
nix_install "Wget" "nixpkgs.wget"
