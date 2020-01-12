#!/usr/bin/env bash

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
        args="--system \
            --home /var/empty \
            --shell /bin/false"
    else
        args="--user-group \
            --create-home \
            --shell /bin/bash"
    fi

    execute \
        "useradd \
            --key UMASK=022 \
            --comment '$USER_NAME' \
            $args \
            $USER" \
        "Create user: $USER" \
        "sudo"

    # Sometimes SSH access is prohibited because user is locked
    # Unlock the user by deleting its password
    execute \
        "passwd -d $USER" \
        "Make user passwordless" \
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

harden() {

    local -r path="$1"
    local -r user="$2"
    local -r group="$3"
    local -r file_permission="$4"   # e.g. 600
    local -r dir_permission="$5"    # e.g. 700

    # CRITICAL: change permissions of the folder and contents
    sudo mkdir -p "$path"

    # Own the folder
    sudo chown -R "$user":"$group" "$path"

    # Make all files inside rw-------
    sudo find "$path" -maxdepth 2 -type f -exec chmod "$file_permission" {} ';'

    # Make all directories inside rwx------
    sudo find "$path" -maxdepth 2 -type d -exec chmod "$dir_permission" {} ';'

    # Make folder rwx------
    sudo chmod "$dir_permission" "$path"

    print_result "$?" "Set strict permission of $path"

}
