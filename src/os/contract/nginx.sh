#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Nginx\n\n"

add_user "nginx" "Nginx" "system"

harden "/var/log/nginx" "nginx" "nginx" 640 750
