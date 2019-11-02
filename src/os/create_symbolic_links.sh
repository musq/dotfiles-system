#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_full_path_symlinks() {

    declare -a FILES_TO_SYMLINK=(

        "etc/git/git-commit-template"

        "etc/nginx/conf.d/default.conf"
        "etc/nginx/conf.d/helpers/ssl.conf"
        "etc/nginx/mime.types"
        "etc/nginx/nginx.conf"

        "etc/ssh/ssh_config"
        "etc/ssh/sshd_config"

        "etc/skel"

        "lib/systemd/system/nginx.service"

        "usr/local/bin/fzf-tmux"
        "usr/local/bin/git-icdiff"

    )

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    for i in "${FILES_TO_SYMLINK[@]}"; do

        sourceFile="$(cd .. && pwd)/$i"
        targetFile="/$i"

        create_symlink "$sourceFile" "$targetFile" "$@"

    done

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n ● Create symbolic links\n\n"

    create_full_path_symlinks "$@"

}

main "$@"
