#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

source_bash_files() {

    declare -r CURRENT_DIRECTORY="$(pwd)"

    declare -r -a FILES_TO_SOURCE=(
        "bash_aliases"
        "bash_autocomplete"
        "bash_exports"
        "bash_functions"
        "bash_options"
        "bash_prompt"
    )

    local file=""
    local i=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    for i in ${!FILES_TO_SOURCE[*]}; do

        file="$HOME/.${FILES_TO_SOURCE[$i]}"

        [ -r "$file" ] \
            && . "$file"

    done

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # shellcheck disable=SC2164
    cd "$CURRENT_DIRECTORY"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

source_bash_files
unset -f source_bash_files
