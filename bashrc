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
HISTFILESIZE=2000000
HISTTIMEFORMAT="%F %T "

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history"

# efficient history jump - up/down only find history entries with same fragment
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

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
export GIT_PS1_SHOWUPSTREAM="auto"

if [ "$color_prompt" = yes ]; then
    PS1='\t|\[\033[0;35m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[38;5;11m\]$(__git_ps1 "(%s)") \[\033[0m\]\\$ '
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

# PS1="\[\033[G\]$PS1"

# Virtual ENV stuff
add_venv_info () {
    if [ -z "$VIRTUAL_ENV_DISABLE_PROMPT" ] ; then
        VIRT_ENV_TXT=""
        if [ "x" != x ] ; then
            VIRT_ENV_TXT=""
        else
            if [ "`basename \"$VIRTUAL_ENV\"`" = "__" ] ; then
                # special case for Aspen magic directories
                # see http://www.zetadev.com/software/aspen/
                VIRT_ENV_TXT="[`basename \`dirname \"$VIRTUAL_ENV\"\``]"
            elif [ "$VIRTUAL_ENV" != "" ]; then
                VIRT_ENV_TXT="(`basename \"$VIRTUAL_ENV\"`)"
            fi
        fi
        if [ "${VIRT_ENV_TXT}" != "" ]; then
           echo ${VIRT_ENV_TXT}" "
        fi
    fi
}

# Now we construct the prompt.
# in my case a bunch of lines constructing the complete PS1
# somewhere call the add_venv_info function like below

PS1="\[$(add_venv_info)\]"${PS1}


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

# general aliases
alias ll='ls -aGlF'
alias la='ls -AG'
alias l='ls -CFG'
alias cl="clear"
alias ..="cd .."

#history grep alias
alias ghist='history | grep'

#git alias list
alias ggs='git status -sb'
alias gga='git add'
alias ggpl='git pull'
alias ggplps='git pull && git push'
alias ggps='git push'
alias ggct='git commit'
alias ggcl='git clone'
alias ggck='git checkout'
alias ggb='git branch'
alias ggdm='git diff origin/master..HEAD'
alias gglsdiff='git diff --name-only `git symbolic-ref --short HEAD` master'
alias ggr='git checkout --'
alias ggresetall='git clean -df && git checkout -- .'
#alias ggcleanbranches='git checkout master; git branch --merged master | grep -v "\* master" | xargs -n 1 -p git branch -d'
alias ggcleanbranches="git checkout master && git fetch -p && git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D"
alias ggt='git tag'
alias ggpsu='git push --set-upstream origin `git symbolic-ref --short HEAD`'
alias ggfetchandclean='git fetch -p' #After fetching, remove any remote-tracking references that no longer exist on the remote
alias ggrb='git rebase -i $(git merge-base master $(git rev-parse --abbrev-ref HEAD))' #Interactively rebases back from HEAD to the point a branch was made
alias gglg='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias ggfetchall='git fetch -vp'

#mac iterm only - open new tab at same location
alias newtab='open . -a iterm'

#gpg alias list
alias gpgfing="gpg --fingerprint | grep -A1 fing | sed -e '/^--$/d' -e 's/Key fingerprint =//g' -e 's/ *//g' -e ':a' -e 'N' -e 's/\nuid/ \# /g' | tr -s '  '"
#gpg view recipients
alias gpgrecipients="gpg --list-only --no-default-keyring --secret-keyring /dev/null"
#gpg trust all installed keys
alias gpgtrustall='for fprint in $(gpg --list-public-keys --fingerprint --with-colons |grep fpr|cut -d: -f10); do echo "$fprint:6:" | gpg --import-ownertrust; done'
alias gpgi='gpg --import'
alias gpgdel='gpg --delete-keys'

#eyaml
alias eyamlstring='eyaml encrypt -n gpg --gpg-always-trust --gpg-recipients-file hieradata/recipients/all.recipients -s'
alias eyamledit='eyaml edit -n gpg --gpg-always-trust --gpg-recipients-file hieradata/recipients/all.recipients'

#aws accounts list
alias listaccounts="aws --profile awsbillingmaster organizations list-accounts | jq --raw-output '.[] |.[] | select(.Status == \"ACTIVE\")| [.Id,.Name] | @tsv' | sort -k2"

# xkcd pw gen
alias xkcdpw="curl -s https://raw.githubusercontent.com/PercussiveRepair/google-10000-english/master/google-10000-english-usa-no-swears-medium.txt | sort -R | tail -n 4 | tr -d '\n' | tr 'o' '0'; echo"

#location slack status
slackstatus () {
  LOCATIONIP=$(curl -s icanhazip.com)
  TOKEN=$(cat ~/.ssh/slacktoken)
  TRAINSTATUS="%7B%0D%0A%20%20%20%20%22status_text%22%3A%20%22on%20the%20train%22%2C%0D%0A%20%20%20%20%22status_emoji%22%3A%20%22%3Apizzatrain%3A%22%0D%0A%7D" #176.12
  ALDWYCHSTATUS="%7B%0D%0A%20%20%20%20%22status_text%22%3A%20%22Aldwych%20House%22%2C%0D%0A%20%20%20%20%22status_emoji%22%3A%20%22%3Abank%3A%22%0D%0A%7D" #89.197.133
  HOMESTATUS="%7B%0D%0A%20%20%20%20%22status_text%22%3A%20%22WFH%22%2C%0D%0A%20%20%20%20%22status_emoji%22%3A%20%22%3Achildren_crossing%3A%22%0D%0A%7D" #82.16.134.66
  BLANKSTATUS="%7B%0D%0A%20%20%20%20%22status_text%22%3A%20%22%22%2C%0D%0A%20%20%20%20%22status_emoji%22%3A%20%22%22%0D%0A%7D"
  if echo $LOCATIONIP | grep -q "176.12"; then
    curl -H "Authorization: Bearer $TOKEN" -X POST https://slack.com/api/users.profile.set?profile=$TRAINSTATUS
  elif echo $LOCATIONIP | grep -q "89.197.133"; then
    curl -H "Authorization: Bearer $TOKEN" -X POST https://slack.com/api/users.profile.set?profile=$ALDWYCHSTATUS
  elif echo $LOCATIONIP | grep -q "82.16.134.66"; then
    curl -H "Authorization: Bearer $TOKEN" -X POST https://slack.com/api/users.profile.set?profile=$HOMESTATUS
  else curl -H "Authorization: Bearer $TOKEN" -X POST https://slack.com/api/users.profile.set?profile=$BLANKSTATUS
  fi
}

#chaim alias list
alias cg="chaim --gui"

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
complete -C '/usr/local/bin/aws_completer' aws
export PATH=/usr/local/aws/bin:$PATH

# git completion from https://github.com/git/git/blob/master/contrib/completion
if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

## MISC ##
export EDITOR=vim
export PACKER=$(which packer)

# add scripts to path
export PATH=$PATH:/Users/jayharrison/repos/scripts:/Users/jayharrison/repos/opsscripts/admin-scripts

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# added by travis gem
[ -f /Users/jayharrison/.travis/travis.sh ] && source /Users/jayharrison/.travis/travis.sh
export PATH=$PATH:/Users/jayharrison/repos/opsbag/.bin
export C2HBAG_ROOT=/Users/jayharrison/repos/opsbag
export PATH=$PATH:/opt/bgch/chaim
