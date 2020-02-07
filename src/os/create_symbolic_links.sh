#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_full_path_symlinks() {

    declare -a FILES_TO_SYMLINK=(

        "etc/git/git-commit-template"

        "etc/nginx/conf.d/default.conf"
        "etc/nginx/conf.d/helpers/proxy_params"
        "etc/nginx/conf.d/helpers/ssl.conf"
        "etc/nginx/mime.types"
        "etc/nginx/nginx.conf"

        "etc/ssh/ssh_config"
        "etc/ssh/sshd_config"

        "etc/skel"

        "usr/local/bin/fzf-tmux"
        "usr/local/bin/git-icdiff"

        "usr/local/lib/systemd/system/duplicati.service"
        "usr/local/lib/systemd/system/duplicati.timer"
        "usr/local/lib/systemd/system/nginx.service"
        "usr/local/lib/systemd/system/postgresql.service"

        "usr/local/sbin/duplicati-backup"

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
