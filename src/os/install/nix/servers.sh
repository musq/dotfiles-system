#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Servers\n\n"

nix_install "NGINX" "nixpkgs.nginx"
nix_install "OpenSSL" "nixpkgs.openssl"
