#!/bin/bash

answer_is_yes() {
    [[ "$REPLY" =~ ^[Yy]$ ]] \
        && return 0 \
        || return 1
}

ask() {
    print_question "$1"
    read -r
}

ask_for_confirmation() {
    print_question "$1 (y/n) "
    read -r -n 1
    printf "\n"
}

ask_for_sudo() {

    # Ask for the administrator password upfront.

    sudo -v &> /dev/null

    # Update existing `sudo` time stamp
    # until this script has finished.
    #
    # https://gist.github.com/cowboy/3118588

    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done &> /dev/null &

}

cmd_exists() {

    if [ "$2" == "sudo" ]; then
        sudo -i command -v "$1" &> /dev/null
    else
        command -v "$1" &> /dev/null
    fi

}

containsElement () {

    # Check if a bash array contains a value
    # https://stackoverflow.com/a/8574392

    local e match="$1"
    shift

    for e; do
        [[ "$e" == "$match" ]] \
            && return 0;
    done

    return 1

}

create_symlink() {

    local -r sourceFile="$1"
    local -r targetFile="$2"

    local skipQuestions=false

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    skip_questions "$3" \
        && skipQuestions=true

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ ! -e "$targetFile" ]; then

        execute \
            "mkdir -p $(dirname "$targetFile") \
                && ln -fs $sourceFile $targetFile" \
            "$targetFile → $sourceFile" \
            "sudo"

    elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
        print_success "$targetFile → $sourceFile"

    else

        if "$skipQuestions"; then

            execute \
                "rm -rf $targetFile \
                    && ln -fs $sourceFile $targetFile" \
                "$targetFile → $sourceFile" \
                "sudo"

        else

            ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
            if answer_is_yes; then

                execute \
                    "rm -rf $targetFile \
                        && ln -fs $sourceFile $targetFile" \
                    "$targetFile → $sourceFile" \
                    "sudo"

            else
                print_error "$targetFile → $sourceFile"
            fi

        fi

    fi

}

execute() {

    local CMDS="$1"
    local -r MSG="${2:-$1}"
    local -r TMP_FILE="$(mktemp /tmp/XXXXX)"

    if [ "$3" == "sudo" ]; then
        # https://stackoverflow.com/questions/5560442/how-to-run-two-commands-in-sudo
        CMDS="sudo -i -- bash -c \"$CMDS\""
    fi

    local exitCode=0
    local cmdsPID=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If the current process is ended,
    # also end all its subprocesses.

    set_trap "EXIT" "kill_all_subprocesses"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Execute commands in background

    eval "$CMDS" \
        &> /dev/null \
        2> "$TMP_FILE" &

    cmdsPID=$!

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Show a spinner if the commands
    # require more time to complete.

    show_spinner "$cmdsPID" "$CMDS" "$MSG"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Wait for the commands to no longer be executing
    # in the background, and then get their exit code.

    wait "$cmdsPID" &> /dev/null
    exitCode=$?

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Print output based on what happened.

    print_result $exitCode "$MSG"

    if [ $exitCode -ne 0 ]; then
        print_error_stream < "$TMP_FILE"
    fi

    rm -rf "$TMP_FILE"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    return $exitCode

}

get_answer() {
    printf "%s" "$REPLY"
}

get_os() {

    local os=""
    local kernel=""
    local distribution=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    kernel="$(get_os_kernel)"

    if [ "$kernel" == "Darwin" ]; then
        os="macos"
    elif [ "$kernel" == "Linux" ]; then

        distribution="$(get_os_distribution)"

        local debianDistros=("Debian" "Ubuntu")

        if containsElement "$distribution" "${debianDistros[@]}"; then
            os="debian"
        fi

    fi

    printf "%s" "$os"

}

get_os_distribution() {

    local distribution=""
    local kernel=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    kernel="$(get_os_kernel)"

    if [ "$kernel" == "Darwin" ]; then
        distribution="Mac"
    elif [ "$kernel" == "Linux" ]; then
        distribution="$(lsb_release -si)"
    fi

    printf "%s" "$distribution"

}

get_os_kernel() {

    local kernel="$(uname -s)"
    printf "%s" "$kernel"

}

get_os_version() {

    local os=""
    local version=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    os="$(get_os)"

    if [ "$os" == "macos" ]; then
        version="$(sw_vers -productVersion)"
    elif [ "$os" == "ubuntu" ]; then
        version="$(lsb_release -sr)"
    elif [ "$os" == "debian" ]; then
        version="$(lsb_release -sr)"
    fi

    printf "%s" "$version"

}

is_git_repository() {
    git rev-parse &> /dev/null
}

mkd() {
    if [ -n "$1" ]; then
        if [ -e "$1" ]; then
            if [ ! -d "$1" ]; then
                print_error "$1 - a file with the same name already exists!"
            else
                print_success "$1"
            fi
        else
            execute "mkdir -p $1" "$1"
        fi
    fi
}

print_error() {
    print_in_red "   [✖] $1 $2\n"
}

print_error_stream() {
    while read -r line; do
        print_error "↳ ERROR: $line"
    done
}

print_in_color() {
    printf "%b" \
        "$(tput setaf "$2" 2> /dev/null)" \
        "$1" \
        "$(tput sgr0 2> /dev/null)"
}

print_in_cyan() {
    print_in_color "$1" 6
}

print_in_green() {
    print_in_color "$1" 2
}

print_in_purple() {
    print_in_color "$1" 5
}

print_in_red() {
    print_in_color "$1" 1
}

print_in_yellow() {
    print_in_color "$1" 3
}

print_question() {
    print_in_yellow "   [?] $1"
}

print_result() {

    if [ "$1" -eq 0 ]; then
        print_success "$2"
    else
        print_error "$2"
    fi

    return "$1"

}

print_success() {
    print_in_green "   [✔] $1\n"
}

print_warning() {
    print_in_yellow "   [!] $1\n"
}

set_trap() {

    trap -p "$1" | grep "$2" &> /dev/null \
        || trap '$2' "$1"

}

skip_questions() {

     while :; do
        case $1 in
            -y|--yes) return 0;;
                   *) break;;
        esac
        shift 1
    done

    return 1

}

show_spinner() {

    local -r FRAMES='/-\|'

    # shellcheck disable=SC2034
    local -r NUMBER_OR_FRAMES=${#FRAMES}

    local -r CMDS="$2"
    local -r MSG="$3"
    local -r PID="$1"

    # shellcheck disable=SC2034
    local i=0
    local frameText=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Note: In order for the Travis CI site to display
    # things correctly, it needs special treatment, hence,
    # the "is Travis CI?" checks.

    if [ "$TRAVIS" != "true" ]; then

        # Provide more space so that the text hopefully
        # doesn't reach the bottom line of the terminal window.
        #
        # This is a workaround for escape sequences not tracking
        # the buffer position (accounting for scrolling).
        #
        # See also: https://unix.stackexchange.com/a/278888

        printf "\n\n\n"
        tput cuu 3

        tput sc

    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Display spinner while the commands are being executed.

    while kill -0 "$PID" &>/dev/null; do

        frameText="   [${FRAMES:i++%NUMBER_OR_FRAMES:1}] $MSG"

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Print frame text.

        if [ "$TRAVIS" != "true" ]; then
            printf "%s\n" "$frameText"
        else
            printf "%s" "$frameText"
        fi

        sleep 0.2

        # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        # Clear frame text.

        if [ "$TRAVIS" != "true" ]; then
            tput rc
        else
            printf "\r"
        fi

    done

}

user_is_root () {
    return "$(id -u)"
}
# Usage:
# if user_is_root; then
#     echo "Current user is root"
# else
#     echo "Current user is not root"
# fi

user_has_sudo() {
    local prompt

    prompt=$(sudo -nv 2>&1)
    # shellcheck disable=SC2181
    if [ $? -eq 0 ]; then
        echo "has_sudo__pass_set"
    elif echo "$prompt" | grep -q '^sudo:'; then
        echo "has_sudo__needs_pass"
    else
        echo "no_sudo"
    fi
}
# Usage:
# HAS_SUDO=$(user_has_sudo)
# case "$HAS_SUDO" in
# has_sudo__pass_set)
#     echo "User has sudo and currently has access to it"
#     ;;
# has_sudo__needs_pass)
#     echo "User has sudo, but needs to enter password to access it"
#     ;;
# *)
#     echo "User does not have sudo"
#     ;;
# esac
