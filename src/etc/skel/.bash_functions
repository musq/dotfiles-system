#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Execute arithmetic operations

eq() {
    set -f
    echo "$@" | bc
    set +f
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create new directories and enter the first one.

mkd() {
    if [ -n "$*" ]; then

        mkdir -p "$@"
        #      └─ make parent directories if needed

        cd "$@" \
            || exit 1

    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Kill all processes by name

nkill() {

    if [ -z "$1" ]; then
        echo "Please specify name of a process";
    else
        processes_count="$(nlist "$1" | wc -l)"

        ask_for_confirmation "$processes_count processes found. Are you sure you want to kill them?"

        if answer_is_yes; then
            nlist "$1" | awk '{print $2}' | xargs kill -9
        fi
    fi

}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# List all processes by name

nlist() {
    if [ -z "$1" ]; then
        echo "Please specify name of a process";
    else
        # shellcheck disable=SC2009
        ps auxw | grep "$1"
    fi
}
