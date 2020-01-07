#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Postgres\n\n"

add_user "postgres" "Postgres"

PG_HOME="/var/lib/pgsql"
PG_DATA="$PG_HOME/data"

harden "$PG_HOME" "postgres" "postgres" 640 750
harden "/run/postgresql" "postgres" "postgres" 640 750

# shellcheck disable=SC2086
if sudo bash -c '[[ -e "'$PG_DATA'" ]]'; then
    print_success "Cluster already initialized"
else

    execute \
        "$NIX_DEFAULT_BIN/initdb \
            --allow-group-access \
            --encoding=UTF8 \
            --locale=C.UTF-8 \
            --pgdata=$PG_DATA" \
        "Initialize cluster" \
        "sudo" \
        "postgres"

fi

execute \
    "systemctl enable postgresql \
        && systemctl reload-or-restart postgresql" \
    "Systemd - Enable and reload postgresql" \
    "sudo"
