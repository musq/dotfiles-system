#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Servers\n\n"

nix_install "Nginx" "nixpkgs.nginx"
nix_install "OpenSSL" "nixpkgs.openssl"
