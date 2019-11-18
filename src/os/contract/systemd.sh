#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Systemd\n\n"

execute \
    "systemctl enable duplicati.timer \
        && systemctl restart duplicati.timer" \
    "Duplicati - Enable and restart timer" \
    "sudo"
