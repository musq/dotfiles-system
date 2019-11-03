#!/usr/bin/env bash

# Remove all previous environment defined aliases.
unalias -a

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alias ll='ls -laF'

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Copy and paste

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Enable color support.

if [ -x /usr/bin/dircolors ]; then

    if test -r ~/.dircolors; then
        eval "$(dircolors -b ~/.dircolors)"
    fi

    alias dir="dir --color=auto"
    alias egrep="egrep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias grep="grep --color=auto"
    alias ls="ls --color=auto"
    alias vdir="vdir --color=auto"

fi
