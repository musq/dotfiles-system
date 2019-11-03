#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n ● Installs\n"


skipQuestions=false

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

skip_questions "$1" \
    && skipQuestions=true

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

OS="$(get_os)"

if [ ! -e "$OS/main.sh" ]; then
    print_error "Unidentified OS - Ignoring package install"
    exit 1
fi

./"$OS"/main.sh

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if ! cmd_exists "nix" "sudo"; then

    print_in_purple "\n   Install Nix package manager\n\n"

    if "$skipQuestions"; then

        # Run installer non-interactively
        # https://www.igorkromin.net/index.php/2017/04/12/invoking-interactive-shell-scripts-non-interactively

        echo | sh <(curl https://nixos.org/nix/install) --daemon

    else
        sh <(curl https://nixos.org/nix/install) --daemon
    fi

fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if cmd_exists "nix" "sudo"; then
    ./nix/main.sh "$@"
fi
