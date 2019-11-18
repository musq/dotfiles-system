#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_full_path_configs() {

    declare -a FILES_TO_SYMLINK=(

        "etc/duplicati/directories.txt"

    )

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    for i in "${FILES_TO_SYMLINK[@]}"; do

        sourceFile="$(cd .. && pwd)/$i"
        targetFile="/$i"

        # shellcheck disable=SC2086
        if sudo bash -c '[[ -e "'$targetFile'" ]]'; then

            print_warning "$sourceFile → $targetFile"

        else

            sudo mkdir -p "$(dirname "$targetFile")"

            # If the target file does not exist, create it by copying
            execute \
                "cp $sourceFile $targetFile" \
                "$sourceFile → $targetFile" \
                "sudo" \
                || print_error "$sourceFile → $targetFile"

        fi

    done

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n ● Create configs\n\n"

    create_full_path_configs

}

main
