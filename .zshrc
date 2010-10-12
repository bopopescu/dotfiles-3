# macports
#export PATH=/opt/local/bin:/opt/local/sbin:$PATH
#export DISPLAY=:0.0

export LANG=ja_JP.UTF-8
#export SHELL=/usr/local/bin/zsh
export PYTHONSTARTUP=$HOME/.pythonrc.py
export DISPLAY=:0.0
# Emacsと同じキー操作を行う
bindkey -e

# history
HISTFILE=$HOME/.zsh-history
HISTSIZE=10000000
SAVEHIST=10000000

# auto complete compile
autoload -U compinit
compinit

# alias
alias emacs='open -a Emacs.app'
alias py=python
alias screen='screen -U'
alias ls='ls -Gfh'
alias vi='vim'
alias less='less -M'
alias grep='grep --color'
alias cp='cp -iv'
alias mv='mv -iv'
alias mysql='mysql5'
alias gd='source $HOME/.zsh_extend/gd/gd.sh'
alias updatedb='$HOME/.zsh_extend/updatedb/updatedb.sh &'

# rsync
alias rsync_gigacast_dev='source $HOME/script/shell/rsync_gigacast_dev'
alias rsync_gigacast_v14_dev='source $HOME/script/shell/rsync_gigacast_v14_dev'
alias rsync_gigacast_plcdn='source $HOME/script/shell/rsync_gigacast_plcdn'
alias rsync_gigacast_aidia='source $HOME/script/shell/rsync_gigacast_aidia'
alias rsync_gigacast_gaitame='source $HOME/script/shell/rsync_gigacast_gaitame'
alias rsync_gigacast_jikiden='source $HOME/script/shell/rsync_gigacast_jikiden'

#alias gd='dirs -v; echo -n "select number: "; read newdir; cd -"$newdir"'

# for crontab
alias crontab="EDITOR=/usr/local/bin/vi crontab"

## prompt
local GREEN=$'%{\e[1;32m%}'
local YELLOW=$'%{\e[1;33m%}'
local BLUE=$'%{\e[1;34m%}'
local DEFAULT=$'%{\e[1;m%}'
PROMPT=$'\n'$GREEN'${USER}@${HOSTNAME} '$YELLOW'%~ '$'\n'$DEFAULT'%(!.#.$) '

## color
#local DEFAULT=$'%{^[[m%}'$
local RED=$'%{^[[1;31m%}'$
#local GREEN=$'%{^[[1;32m%}'$
#local YELLOW=$'%{^[[1;33m%}'$
#local BLUE=$'%{^[[1;34m%}'$
local PURPLE=$'%{^[[1;35m%}'$
local LIGHT_BLUE=$'%{^[[1;36m%}'$
local WHITE=$'%{^[[1;37m%}'$

# less
export PAGER='less'
export LESS='--tabs=4 --no-init --LONG-PROMPT --ignore-case'

#エイリアスも補完対象に設定
setopt complete_aliases

# share history
setopt share_history

## コアダンプサイズを制限
limit coredumpsize 102400

## 出力の文字列末尾に改行コードが無い場合でも表示
unsetopt promptcr

## 色を使う
setopt prompt_subst

## no beep
setopt nobeep

## 内部コマンド jobs の出力をデフォルトで jobs -l にする
setopt long_list_jobs

## 補完候補一覧でファイルの種別をマーク表示
setopt list_types

## サスペンド中のプロセスと同じコマンド名を実行した場合はリジューム
setopt auto_resume

## 補完候補を一覧表示
setopt auto_list

#日本語ファイル名等8ビットを通す
setopt print_eight_bit

## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups

## cd 時に自動で push
setopt autopushd

## 同じディレクトリを pushd しない
setopt pushd_ignore_dups

# ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt mark_dirs

## TAB で順に補完候補を切り替える
setopt auto_menu

## zsh の開始, 終了時刻をヒストリファイルに書き込む
setopt extended_history

## =command を command のパス名に展開する
setopt equals

## TAB で順に補完候補を切り替える
setopt auto_menu

## --prefix=/usr などの = 以降も補完
setopt magic_equal_subst

## ディレクトリ名だけで cd
setopt auto_cd

## カッコの対応などを自動的に補完
setopt auto_param_keys

## ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash

## スペルチェック
setopt correct

## cd conf
# カレントディレクトリ中にサブディレクトリが無い場合に cd が検索するディレクトリのリスト
cdpath=($HOME)
# カレントディレクトリに候補がない場合のみ cdpath 上のディレクトリを候補に出す
zstyle ':completion:*:cd:*' tag-order local-directories path-directories
#cd は親ディレクトリからカレントディレクトリを選択しないので表示させないようにする (例: cd ../<TAB>):
zstyle ':completion:*:cd:*' ignore-parents parent pwd
#LS_COLORSを設定しておく
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#ファイル補完候補に色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

## auto complete conf
# 補完候補を ←↓↑→ でも選択出来るようにする
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' verbose yes
#
#_complete
#普通の補完関数
#_approximate
#ミススペルを訂正した上で補完を行う。
#_match
#*などのグロブによってコマンドを補完できる(例えばvi* と打つとviとかvimとか補完候補が表示される)
#_expand
#グロブや変数の展開を行う。もともとあった展開と比べて、細かい制御が可能
#_history
#履歴から補完を行う。_history_complete_wordから使われる
#_prefix
#カーソルの位置で補完を行う 
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format $YELLOW'%d'$DEFAULT
zstyle ':completion:*:warnings' format $RED'No matches for:'$YELLOW' %d'$DEFAULT
zstyle ':completion:*:descriptions' format $YELLOW'completing %B%d%b'$DEFAULT
zstyle ':completion:*:corrections' format $YELLOW'%B%d '$RED'(errors: %e)%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
# グループ名に空文字列を指定すると，マッチ対象のタグ名がグループ名に使われる。
# したがって，すべての マッチ種別を別々に表示させたいなら以下のようにする
zstyle ':completion:*' group-name ''

#################################################################
# 上記でカラーの設定をしているため上記に該当するコマンド群は下記に書く
# ぶっちゃけfunctionの設定を下記に書けば良いぐらいだと思う
#################################################################

# functionの設定
function history-all { history -E 1 }

# cdを打ったら自動的にlsを打ってくれる関数
function cd(){
    builtin cd $@ && ls -alt;
}

# settei wo kaiteinai
#function chpwd(){
#	_reg_pwd_screennum
#}

# ssh screen name
function ssh_screen(){
	#eval
	server=?${$#}
	screen -t $server ssh "$@"
}
if [ x$TERM = xscreen ]; then
	alias ssh=ssh_screen
fi

#source ~/.zsh_extend/cdd
source $HOME/.zsh_extend/emacs/isemacs.sh
#source $HOME/.zsh_extend/gd/gd.sh

# history
zshaddhistory() {
    local line=${1%%$'\n'}
    local cmd=${line%% *}

    # 以下の条件をすべて満たすものだけをヒストリに追加する
    # 追加したくないコマンドを列挙する
    # この場合、以下のいずれかを満たすコマンドラインがヒストリに追加されなくなる。
    # * 4文字以下である
    # * コマンド名の部分が l, ls, la, ll のいずれかである
    # * コマンド名の部分が c, cd のいずれかである
    # * コマンド名の部分が m, man のいずれかである

    [[ ${#line} -ge 5
        && ${cmd} != (l|l[sal])
        && ${cmd} != (c|cd)
#	&& ${cmd} != (gd)
        && ${cmd} != (m|man)
    ]]
}
 
