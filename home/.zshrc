export PATH=$PATH:$M2_HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
export M2_HOME=$HOME/tool/apache-maven-3.2.5
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`

# NVM [https://github.com/creationix/nvm]
export NVM_DIR="$HOME/.nvm"

nvmrc() {
  [ -n "$(command -v load-nvm)" ] && load-nvm
  
  local nvmrc_path="$(nvm_find_nvmrc)"
  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  fi
}

load-nvm() {
  unalias nvm node npm yarn
  unset -f load-nvm

  if [ -s "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh"
  elif [ -s "$(brew --prefix nvm)/nvm.sh" ]; then
    source "$(brew --prefix nvm)/nvm.sh"
  else
    echo "[nvm.sh] not found"
  fi
}

alias nvm='nvmrc && nvm'
alias node='nvmrc && node'
alias npm='nvmrc && npm'
alias yarn='nvmrc && yarn'


#----- zsh-syntax-highlighting
if [ -f $HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]
then
    source $HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi


# prompt
PROMPT='%m:%F{green}%c%f %n$ '

# git
# ブランチ名を色付きで表示させるメソッド
function rprompt-git-current-branch {
  local branch_name st branch_status

  if [ ! -e  ".git" ]; then
    # gitで管理されていないディレクトリは何も返さない
    return
  fi
  branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    # 全てcommitされてクリーンな状態
    branch_status="%F{green}"
  elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
    # gitに管理されていないファイルがある状態
    branch_status="%F{red}?"
  elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
    # git addされていないファイルがある状態
    branch_status="%F{red}+"
  elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
    # git commitされていないファイルがある状態
    branch_status="%F{yellow}!"
  elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
    # コンフリクトが起こった状態
    echo "%F{red}!(no branch)"
    return
  else
    # 上記以外の状態の場合は青色で表示させる
    branch_status="%F{blue}"
  fi
  # ブランチ名を色付きで表示する
  echo "${branch_status}[$branch_name]"
}

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

# プロンプトの右側(RPROMPT)にメソッドの結果を表示させる
RPROMPT='`rprompt-git-current-branch`'

source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
