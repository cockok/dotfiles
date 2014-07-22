# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

[ -f ~/.bash_completion ] && source ~/.bash_completion

function share_history {
    history -a
    history -c
    history -r
}
PROMPT_COMMAND='share_history'
shopt -u histappend
export HISTSIZE=50000
export HISTIGNORE=ls*:fg*:bg*:history*

if [ -f $HOME/.git-completion.bash ]; then
    source $HOME/.git-completion.bash
fi

if [ -f $HOME/.git-prompt.sh ]; then
    source $HOME/.git-prompt.sh
fi
GIT_PS1_SHOWDIRTYSTATE=true

# User specific aliases and functions
case "$TERM" in
xterm*|rxvt*|putty*|screen*)
  PS1='${debian_chroot:+($debian_chroot)}\[\e[1;32m\]\u@\h\[\e[00m\]:\[\e[1;34m\]\w\[\e[0m\]$(__git_ps1 "(%s)")\$ '
  ;;
*)
  PS1='${debian_chroot:+($debian_chroot)}[$(date +%H:%M:%S)(\#)]\u@\h:\w\$ '
  ;;
esac

# for homebrew
if [ `uname` = "Darwin" ]; then
    PATH=`echo $PATH | sed -e "s/:\/usr\/local\/bin//"`
    export PATH="/usr/local/bin:$PATH"
fi

## set PATH so it includes user's private bin if it exists
#if [ -d ~/pear ] ; then
#    export PATH="~/pear:$PATH"
#fi
if [ -d ~/bin ] ; then
    export PATH="~/bin:$PATH"
fi

export SVN_EDITOR=vim
export EDITOR=vim
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

#export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
#alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
#alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'

# for ruby
if [ -d ~/.rbenv ] ; then
    export PATH="$HOME/.rbenv/shims:$PATH"
    eval "$(rbenv init -)"
fi

# for mac android
#if [ -d /Developer/android-sdk-mac_x86/platform-tools ] ; then
#    export PATH=/Developer/android-sdk-mac_x86/platform-tools:$PATH
#fi

# for go lang
if [ -x "`which go`" ]; then
    export GOROOT=`go env GOROOT`
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
fi

if [ -x "`which adb`"]; then
    export PATH=$PATH:~/Development/adt-bundle-mac-x86_64-20140702/sdk/platform-tools
    #export PATH=$PATH:/Applications/Android\ Studio.app/sdk/platform-tools
fi

# The next line updates PATH for the Google Cloud SDK.
# The next line enables bash completion for gcloud.
if [ -d ~/google-cloud-sdk ] ; then
    source '~/google-cloud-sdk/path.bash.inc'
    source '~/google-cloud-sdk/completion.bash.inc'
fi
