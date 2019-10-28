#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   NGINX\n\n"

add_group "www-data" "system"
add_user "nginx" "NGINX" "system"
add_user_to_group "www-data" "nginx"

harden "/var/log/nginx" "nginx" "www-data" 640 750
