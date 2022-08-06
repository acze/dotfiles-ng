# Git integration for prompt
autoload -Uz vcs_info

# Needed for functions usage in prompt (vcs_info, code())
setopt promptsubst

# This function is used to display signals in prompt
code () {
  if (( $1 > 128 )); then
    echo "SIG$(kill -l $1)"
  else
    echo $1
  fi
}

# Needed for live clock updates. Without the crazy logic it conflicts with fzf
TMOUT=1
TRAPALRM() {
      $(ps -ef | grep "$(tty | cut -c 6-).*[f]zf" &>/dev/null)
      if [ $? -ne 0 ]; then
        zle reset-prompt
      fi
}

# This is called every time before rendering a prompt
precmd() {
    # As always first run the system so everything is setup correctly.
    vcs_info
    # And then just set PS1, RPS1 and whatever you want to. This $PS1
    # is (as with the other examples above too) just an example of a very
    # basic single-line prompt. See "man zshmisc" for details on how to
    # make this less readable. :-)
    if [[ -z ${vcs_info_msg_0_} ]]; then
        # Oh hey, nothing from vcs_info, so we got more space.
        # Let's print a longer part of $PWD...
	export PROMPT='%(?..%F{196}$(code $?) )%F{39}[%f%F{39}%D%f %F{36}%*%f%F{39}]%f %F{159}%n%f:%B%F{15}%~%f%b %# '
    else
        # vcs_info found something, that needs space. So a shorter $PWD
        # makes sense.
	export PROMPT='%(?..%F{196}$(code $?) )%F{39}[%f%F{39}%D%f %F{36}%*%f%F{39}]%f %F{159}%n%f:%B%F{15}%~%f%b %F{46}(${vcs_info_msg_0_})%f %# '
    fi
}

# Don't write 'git' string in prompt, just the branch
zstyle ':vcs_info:git:*' formats '%b'

# Enable jeffreytse/zsh-vi-mode plugin
plugins=(zsh-vi-mode)
source /usr/local/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# fzf needs to be loaded in this function in order to work with zsh-vi-mode plugin
function zvm_after_init() {
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}
