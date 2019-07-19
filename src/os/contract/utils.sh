#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_group() {

    declare -r GROUP="$1"
    declare -r SYSTEM="$2"

    # Check if the group already exists
    if [ "$(getent group "$GROUP")" ]; then
        print_success "Create group: $GROUP"
        return 0
    fi

    # Build arguments
    local args=""

    if [ "$SYSTEM" == "system" ]; then
        args="--system"
    fi

    execute \
        "groupadd \
            $args \
            $GROUP" \
        "Create group: $GROUP" \
        "sudo"

}

add_user() {

    declare -r USER="$1"
    declare -r USER_NAME="$2"
    declare -r SYSTEM="$3"

    # Check if the user already exists
    if [ "$(getent passwd "$USER")" ]; then
        print_success "Create user: $USER"
        return 0
    fi

    # Build arguments
    local args=""

    if [ "$SYSTEM" == "system" ]; then
        args="--system"
    else
        args="--user-group \
            --create-home \
            --shell /bin/bash \
            --comment '$USER_NAME'"
    fi

    execute \
        "useradd \
            --key UMASK=022 \
            $args \
            $USER" \
        "Create user: $USER" \
        "sudo"

}

add_user_to_group() {

    declare -r GROUP="$1"
    declare -r USER="$2"

    execute \
        "usermod \
            --append \
            --groups $GROUP \
            $USER" \
        "Add user to group: $GROUP - $USER" \
        "sudo"

}
