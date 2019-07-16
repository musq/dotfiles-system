#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

init_backup() {

    mkdir -p "$HOME/.backups/dotfiles-system-backup"

    # get the version
    LAST_VERSION=$(
        find "$HOME/.backups/dotfiles-system-backup" \
            -iname 'v[[:alnum:]]*' \
            -type d | \
        sed "s/.*\///" | \
        cut -c 2- | \
        sort -n | \
        tail -1
    )

    CURRENT_VERSION=$(($LAST_VERSION + 1))

    BACKUP_DIR="$HOME/.backups/dotfiles-system-backup/v$CURRENT_VERSION"

    mkd "$BACKUP_DIR" \
        || ( print_error "Failed to create backup directory" && exit 1 )

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

finish_backup() {

    # https://unix.stackexchange.com/questions/8430/how-to-remove-all-empty-directories-in-a-subtree
    find "$BACKUP_DIR" -type d -empty -delete > /dev/null 2>&1

    # The following rmdir command is added as hack to delete the topmost
    # directory on MacOS. The exact bug is mentioned in the link.
    # https://unix.stackexchange.com/questions/497666/relative-path-potentially-not-safe-error-with-find-delete-on-macos
    rmdir "$BACKUP_DIR" > /dev/null 2>&1

    if [ -d "$BACKUP_DIR" ]; then
        print_success "Backup created successfully"
    else
        print_success "Backup is not needed, hence v$CURRENT_VERSION has been deleted"
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

copy_file() {

    # If the source file/directory exists and is not a symlink,
    # take a backup
    if { [ -e "$1" ] || [ -d "$1" ]; } && [ ! -L "$1" ]; then
        execute \
            "cp -a $1 $2" \
            "$1 → $2" \
            || print_error "$1 → $2"
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_full_path_backup() {

    declare -a FILES_TO_BACKUP=(

        "etc/git/git-commit-template"

        "etc/ssh/ssh_config"
        "etc/ssh/sshd_config"

        "etc/skel"

        "usr/local/bin/fzf-tmux"
        "usr/local/bin/git-icdiff"

    )

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    for i in "${FILES_TO_BACKUP[@]}"; do

        sourceFile="/$i"
        targetFile="$BACKUP_DIR/$i"

        mkdir -p "$(dirname $targetFile)"

        copy_file "$sourceFile" "$targetFile"

    done

}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n ● Create backup\n\n"

    init_backup

    create_full_path_backup

    finish_backup
}

main
