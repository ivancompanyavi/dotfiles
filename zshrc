# ZSH Performance debug helpers --- {{{
# Uncomment this & run zprof on the shell to debug time taken by plugins
# More: https://blog.mattclemente.com/2020/06/26/oh-my-zsh-slow-to-load/
# zmodload zsh/zprof

# Uncomment this & run 'timezsh' to track overall zsh load time
# timezsh() {
#   shell=${1-$SHELL}
#   for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
# }
#
# }}}

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="clean-minimal"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git z)

# User configuration
export PATH="$PATH:/usr/local/mysql/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# ZSH displays error with /usr/local permissions
ZSH_DISABLE_COMPFIX="true"

source $ZSH/oh-my-zsh.sh


# Persist normal non-vi behaviour
# Reference to key & values:
# https://betterprogramming.pub/master-mac-linux-terminal-shortcuts-like-a-ninja-7a36f32752a6
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^w' backward-kill-word
bindkey '^r' fzf
bindkey '^e' end-of-line
bindkey '^a' beginning-of-line
bindkey "^?" backward-delete-char
bindkey "^u" backward-kill-line
bindkey "^y" yank

# Make mode change lag go away
export KEYTIMEOUT=1
# }

# Sourcing should be after zle reverse search is registered
source ~/.fzf.zsh

######### ALIAS

# Use Neovim as "preferred editor"
export VISUAL=nvim
export EDITOR="$VISUAL"

# fix terminals to send ctrl-h to neovim correctly
[[ -f "~/.$TERM.ti" ]] && tic ~/.$TERM.ti


## For yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

loadCollimator() {
  tmux new-window -kS -n code -t 1 -c ~/projects/collimator/src/services/frontend nvim .
  tmux new-window -kS -n git -t 2 -c ~/projects/collimator/src/services/frontend lazygit
  tmux new-window -kS -n npm -t 3 -c ~/projects/collimator/src/services/frontend "nvm use;yarn start"
  tmux select-window -t code
}

alias colli="loadCollimator"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/ivancompanyavi/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/ivancompanyavi/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/ivancompanyavi/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/ivancompanyavi/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

