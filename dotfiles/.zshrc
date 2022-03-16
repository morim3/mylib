# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/morim/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
export LANG=ja_JP.UTF-8

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select=2

setopt auto_param_slash       # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt mark_dirs              # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt auto_menu              # 補完キー連打で順に補完候補を自動で補完
setopt interactive_comments   # コマンドラインでも # 以降をコメントと見なす
setopt magic_equal_subst      # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt complete_in_word       # 語の途中でもカーソル位置で補完
setopt print_eight_bit
setopt nobeep

autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

alias grep='grep --color=auto'

export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="$HOME/local/bin:$PATH"
export PATH="$HOME/local/bin/mylib:$PATH"
export PYTHONPATH="$HOME/pycharm_tmp/HMIRL/:$PYTHONPATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
