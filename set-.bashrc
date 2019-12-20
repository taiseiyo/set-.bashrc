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
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias python='/usr/local/bin/python3.7'
alias cat-bus-time="~/bin/cat-bus-time < ~/tmp/bus-time-table/Sannomiya"
alias suspend='systemctl suspend'
export PAGER=less


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

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

kgproxy(){
    export http_proxy="http://proxy.ksc.kwansei.ac.jp:8080"
    export https_proxy="http://proxy.ksc.kwansei.ac.jp:8080"
    export ftp_proxy="http://proxy.ksc.kwansei.ac.jp:8080"
    cp /etc/apt/aptkg /etc/apt/apt.conf
}

unkgproxy(){
    unset http_proxy
    unset https_proxy
    unset ftp_proxy
    cp /etc/apt/aptunkg /etc/apt/apt.conf
}

cd(){
    builtin cd "$@" && ls
}

if test -z "$DISPLAY"; then 
    setfont /usr/share/consolefonts/Lat7-Terminus32x16.psf.gz
fi


export PYTHONPATH=$HOME/lib/python:/usr/local/lib/python3.7/site-packages:/usr/lib/python3/dist-packages


alias LINE='xpywm 2>/tmp/xpywm.log &'

function dict() {
    grep $1 /path/to/unix.txt -A 1 -wi --color | less
}


 
function p-build(){
    sudo apt install build-essential checkinstall libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev && ./configure -with-ensurepip && sudo make && sudo make altinstall
}

if [ $USER = "taisei" ];then
    PS1="\[\e[1;33m\]\u@\h:\w\\$\[\e[m\] "
fi

export PATH="$PATH:~/.local/lib/python3.7/site-packages/:~/bin/command/:~/bin/work-command/"

export TEXINPUTS=.:~/lib/texmf//:/usr/share/texlive/texmf-dist//:/etc/texmf//

cde () {
        EMACS_CWD=`emacsclient -e "(return-current-working-directory-to-shell)" | sed 's/^"\(.*\)"$/\1/'`
        cd "$EMACS_CWD"
}

sde (){
    buf=`pwd`
    [ -n "$1" ] && buf=`readlink -f $1`
    emacsclient -e "(find-file \"$buf\")" > /dev/null
}
