#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   OpenSSL\n\n"

SSL_DHPARAM="/etc/ssl/private/dhparam.pem"

# shellcheck disable=SC2086
if sudo bash -c '[ ! -e "'$SSL_DHPARAM'" ]'; then
    execute \
        "openssl dhparam -dsaparam -out $SSL_DHPARAM 2048" \
        "dhparam - $SSL_DHPARAM" \
        "sudo"
else
    print_success "dhparam - $SSL_DHPARAM"
fi

harden "$(dirname "$SSL_DHPARAM")" "root" "root" 600 700
