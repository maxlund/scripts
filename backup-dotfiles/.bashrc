# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
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
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm|xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    if [[ ${EUID} == 0 ]] ; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
    else
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w \$\[\033[00m\] '
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h \w \$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# ******* git stuff *******
# **************************************************************************************
alias gs='git status'
alias gl='git log'
alias gd='git diff'
alias gg='git gui'
alias glist='git stash list'

gapply() {
    git stash apply stash@{$1}
}

gpop() {
    git stash pop stash@{$1}
}

gcheck() {
    git branch | grep "$1" | xargs git checkout
}

gadd() {
    git add $(cut -d ":" -f2 <<< $(gs | grep "$1"))
}

gunstage() {
    git restore --staged $(cut -d ":" -f2 <<< $(gs | grep "$1"))
}

grestore() {
    git restore $(cut -d ":" -f2 <<< $(gs | grep "$1"))
}

export PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\] @ \[\033[0;36m\]\h \w\[\033[0;32m\]$(__git_ps1)\n\[\033[0;32m\]└─\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\] ▶\[\033[0m\] '

set-terminal-title() {
    host=$1
    PROMPT_COMMAND='echo -en "\033]0;$host\a"'
    eval $PROMPT_COMMAND
}

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

alias g++='echo "Use w++17 (warnings) or e++17 (warnings are errors)."'
alias g++11="\g++ -std=c++11 -g"
alias w++11="\g++ -std=c++11 \${CCFLAGS}"
alias e++11="\g++ -std=c++11 \${CCFLAGS} -Werror"

alias g++17="\g++ -std=c++17 -g"
alias w++17="\g++ -std=c++17 \${CCFLAGS}"
alias e++17="\g++ -std=c++17 \${CCFLAGS} -Werror"
alias pycharm="~/programs/pycharm-2017.2.4/bin/pycharm.sh"
alias gmaps="python3 ~/scripts/map_address.py"
alias fox-dev="~/programs/firefox-dev/firefox"
alias fox="~/programs/firefox/firefox"

alias extend-display="xrandr --output HDMI-A-0 --same-as DisplayPort-0;sleep 1;python ~/scripts/move_windows.py"
alias mirror-display="xrandr --output HDMI-A-0 --same-as DisplayPort-0;"

alias veromix="cd ~/Downloads/veromix/gtk && ./main.py"

shopt -s histappend
HISTFILESIZE=1000000
HISTSIZE=1000000
HISTIGNORE='ls -al:bg:fg:history'
export HISTTIMEFORMAT="%h %d %H:%M:%S "
shopt -s histappend
shopt -s cmdhist
PROMPT_COMMAND='history -a'
export HISTCONTROL=ignorespace:erasedups

if [ -f ~/.bash_aliases ]; then
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

if [ -x /usr/bin/mint-fortune ]; then
     /usr/bin/mint-fortune
fi

# added by Anaconda3 4.2.0 installer
export PATH="/home/max/programs/anaconda3/bin:$PATH"

_python_argcomplete() {
    local IFS=''
    local prefix=
    typeset -i n
    (( lastw=${#COMP_WORDS[@]} -1))
    if [[ ${COMP_WORDS[lastw]} == --*=* ]]; then
        # for bash version 3.2
        flag=${COMP_WORDS[lastw]%%=*}
        set -- "$1" "$2" '='
    elif [[ $3 == '=' ]]; then
      flag=${COMP_WORDS[-3]}
    fi
    if [[ $3 == ssh  && $2 == *@* ]] ;then
        # handle ssh user@instance specially
        prefix=${2%@*}@
        COMP_LINE=${COMP_LINE%$2}"${2#*@}"
    elif [[ $3 == '=' ]] ; then
        # handle --flag=value
        prefix=$flag=$2
        line=${COMP_LINE%$prefix};
        COMP_LINE=$line${prefix/=/ };
        prefix=
    fi
    if [[ $2 == *,* ]]; then
          # handle , separated list
          prefix=${2%,*},
          set -- "$1" "${2#$prefix}" "$3"
          COMP_LINE==${COMP_LINE%$prefix*}$2
    fi
    # Treat --flag=<TAB> as --flag <TAB> to work around bash 4.x bug
    if [[ ${COMP_LINE} == *=  && ${COMP_WORDS[-2]} == --* ]]; then
        COMP_LINE=${COMP_LINE%=}' '
    fi
    COMPREPLY=( $(IFS="$IFS"                   COMP_LINE="$COMP_LINE"                   COMP_POINT="$COMP_POINT"                   _ARGCOMPLETE_COMP_WORDBREAKS="$COMP_WORDBREAKS"                   _ARGCOMPLETE=1                   "$1" 8>&1 9>&2 1>/dev/null 2>/dev/null) )
    if [[ $? != 0 ]]; then
        unset COMPREPLY
        return
    fi
    if [[ $prefix != '' ]]; then
        for ((n=0; n < ${#COMPREPLY[@]}; n++)); do
            COMPREPLY[$n]=$prefix${COMPREPLY[$n]}
        done
    fi
    for ((n=0; n < ${#COMPREPLY[@]}; n++)); do
        match=${COMPREPLY[$n]%' '}
        if [[ $match != '' ]]; then
            COMPREPLY[$n]=${match//? /' '}' '
        fi
    done
    # if flags argument has a single completion and ends in  '= ', delete ' '
    if [[ ${#COMPREPLY[@]} == 1 && ${COMPREPLY[0]} == -* &&
          ${COMPREPLY[0]} == *'= ' ]]; then
        COMPREPLY[0]=${COMPREPLY[0]%' '}
    fi
}
complete -o nospace -F _python_argcomplete "gcloud"

_completer() {
    command=$1
    name=$2
    eval '[[ "$'"${name}"'_COMMANDS" ]] || '"${name}"'_COMMANDS="$('"${command}"')"'
    set -- $COMP_LINE
    shift
    while [[ $1 == -* ]]; do
          shift
    done
    [[ $2 ]] && return
    grep -q "${name}\s*$" <<< $COMP_LINE &&
        eval 'COMPREPLY=($'"${name}"'_COMMANDS)' &&
        return
    [[ "$COMP_LINE" == *" " ]] && return
    [[ $1 ]] &&
        eval 'COMPREPLY=($(echo "$'"${name}"'_COMMANDS" | grep ^'"$1"'))'
}

unset bq_COMMANDS
_bq_completer() {
    _completer "CLOUDSDK_COMPONENT_MANAGER_DISABLE_UPDATE_CHECK=1 bq help | grep '^[^ ][^ ]*  ' | sed 's/ .*//'" bq
}

complete -F _bq_completer bq
complete -o nospace -F _python_argcomplete gsutil

script_link="$( command readlink "$BASH_SOURCE" )" || script_link="$BASH_SOURCE"
apparent_sdk_dir="${script_link%/*}"
if [ "$apparent_sdk_dir" == "$script_link" ]; then
  apparent_sdk_dir=.
fi
sdk_dir="$( command cd -P "$apparent_sdk_dir" > /dev/null && command pwd -P )"
bin_path="$sdk_dir/bin"
export PATH=$bin_path:$PATH
