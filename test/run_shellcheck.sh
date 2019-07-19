#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && source "../src/os/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    # ' At first you're like "shellcheck is awesome" but then you're
    #   like "wtf are we still using bash" '.
    #
    #  (from: https://twitter.com/astarasikov/status/568825996532707330)

    find \
        ../test \
        ../src/os \
        ../src/etc/skel \
        -type f \
        ! -path '../src/etc/skel/.gnupg/*' \
        ! -path '../src/etc/skel/.ssh/*' \
        ! -path '../src/etc/skel/.inputrc' \
        -exec shellcheck \
            -e SC1090 \
            -e SC1091 \
            -e SC2155 \
        {} +

    print_result $? "Run code through ShellCheck"

}

main
