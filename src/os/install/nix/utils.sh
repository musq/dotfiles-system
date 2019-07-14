#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

backup_current_generation() {

    local path="/root/.nix-generation-old"

    local generation=$(sudo -i nix-env --list-generations \
            | grep "current" \
            | awk '{print $1}')

    execute \
        "echo $generation > $path" \
        "Store current generation ($generation) in $path" \
        "sudo"

}

nix_collect_garbage() {

    # Delete all the store directories which are not being used
    # in any other profiles or generations

    execute \
        "nix-store --gc" \
        "Collect garbage" \
        "sudo"

}

nix_install() {

    declare -r FULL_INSTALL="$3"
    declare -r PACKAGE="$2"
    declare -r PACKAGE_READABLE_NAME="$1"

    local installedFlag="$(sudo -i nix-env -qasA $PACKAGE | cut -c1)"

    if [ "$installedFlag" == "I" ]; then
        print_success "$PACKAGE_READABLE_NAME"
    else

        if [ "$FULL_INSTALL" == "no" ]; then
            print_warning "$PACKAGE_READABLE_NAME"
        else

            execute \
                "nix-env --install --attr $PACKAGE" \
                "$PACKAGE_READABLE_NAME" \
                "sudo"

        fi
    fi

}

nix_optimize() {

    # Reduce Nix storage space by hard linking identical files

    execute \
        "nix-store --optimise" \
        "Optimize nix store" \
        "sudo"

    nix_collect_garbage

}

update() {

    # Resynchronize the Nix expressions of all subscribed channels.

    execute \
        "nix-channel --update" \
        "Nix (update)" \
        "sudo"

}

upgrade() {

    # Install the newest versions of all packages installed.

    # List down the attribute names of all the packages which are found
    # in this directory
    local packages=$(grep -r "nix_install " \
        | cut -d "\"" -f4 \
        | grep "nixpkgs" \
        | sed -e :a -e ';$!N;s/\n/ /;ta')

    execute \
        "nix-env --upgrade -A $packages" \
        "Nix (upgrade)" \
        "sudo"

}
