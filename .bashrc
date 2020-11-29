# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
ALIAS_FILE="$XDG_CONFIG_HOME/bash/bash_aliases"
if [ -f "$ALIAS_FILE" ]; then
    . $ALIAS_FILE
elif [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# NVM-specific setup
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


if [ -f "$HOME/.local/bin/trueline.sh" ]; then
    source $XDG_CONFIG_HOME/trueline/extensions.bash
    source $XDG_CONFIG_HOME/trueline/settings.bash
    source $HOME/.local/bin/trueline.sh
elif [ -f "$GOPATH/bin/powerline-go" ]; then
    # Custom prompt using powerline-go
    function _update_ps1() {
        PS1="$(powerline-go -error $? -cwd-max-depth 2 -cwd-max-dir-size 10 -modules venv,cwd,perms,git,time,hg,jobs,exit)"
    }
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

# Show cool PC info when terminal opens
path=$(command -v neofetch) # Gets path of neofetch, if it exists
[ -z "$path" ] || neofetch # Checks for non-empty path before running
