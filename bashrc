# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return


## HISTORY STUFF ##
# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# After each command, append to the history file
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a;"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=500000
HISTFILESIZE=200000
HISTTIMEFORMAT="%F %T "

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history"


## PROMPT STUFF ##

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; 
force_color_prompt=yes

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

# Load in the git branch prompt script from https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
source ~/.git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE="yes"
export GIT_PS1_SHOWUNTRACKEDFILES="yes"
export GIT_PS1_SHOWCOLORHINTS="yes"

if [ "$color_prompt" = yes ]; then
    PS1='\t|\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[38;5;11m\]$(__git_ps1 "(%s)") \[\033[0m\]\\$ '
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

PS1="\[\033[G\]$PS1"


## COLOURS AND ALIASES ##

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

# some more ls aliases
alias ll='ls -aGlF'
alias la='ls -AG'
alias l='ls -CFG'

#history grep alias
alias ghist='history | grep'

#git status alias
alias ggs='git status --short'
alias gga='git add'
alias ggpl='git pull'
alias ggps='git push'
alias ggct='git commit'
alias ggcl='git clone'
alias ggck='git checkout'
alias ggb='git branch'
alias ggdm='git diff origin/master..HEAD'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


## AUTOCOMPLETION ##

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Perform file completion in a case insensitive fashion
bind "set completion-ignore-case on"

# Display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"

#SSH Config Tab Completion
function _ssh_completion() {
perl -ne 'print "$1 " if /^Host (.+)$/' ~/.ssh/config
}
complete -W "$(_ssh_completion)" ssh

#aws cli autocompleter 
#see: http://docs.aws.amazon.com/cli/latest/userguide/cli-command-completion.html
complete -C '/usr/local/bin/aws_completer' aws
export PATH=/usr/local/aws/bin:$PATH


## MISC ##
export EDITOR=vim

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
