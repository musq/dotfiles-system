#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Nix\n\n"


skipQuestions=false

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

skip_questions "$1" \
    && skipQuestions=true

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

full="no"

if ! "$skipQuestions"; then

    ask_for_confirmation "Do you want a minimal install (faster), instead of full (slower)?"
    if answer_is_yes; then
        full="no"
    else
        full="yes"
    fi

fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

backup_current_generation
update
upgrade

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

./build-essentials.sh "$full"

./downloaders.sh "$full"
./editors.sh "$full"
./git.sh "$full"
./misc_tools.sh "$full"
./navigators.sh "$full"
./python.sh "$full"
./servers.sh "$full"

./cleanup.sh
