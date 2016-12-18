# zmodload zsh/datetime
# setopt promptsubst
# PS4='+$EPOCHREALTIME %N:%i> '
# # save file stderr to file descriptor 3 and redirect stderr (including trace
# # output) to a file with the script's PID as an extension
# exec 3>&2 2>/tmp/startlog.$$
# # set options to turn on tracing and expansion of commands contained in the prompt
# setopt xtrace prompt_subst

#
# User configuration sourced by interactive shells
#

# Set the list of directories that Zsh searches for programs.
path=(
  $HOME/bin
  /usr/local/{bin,sbin}
  $path
)

if [[ -d "/run/current-system/sw/" ]]; then
   path=(
       /run/current-system/sw/{bin,sbin}
       $path
   )
fi

if [[ -d "/usr/local/opt/coreutils/libexec/gnubin/" ]]; then
   path=(
       /usr/local/opt/coreutils/libexec/gnubin/
       $path
   )
fi

if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
   source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

export DEFAULT_USER=$USER

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

# I like my case-semi-sensitive completion better
zstyle ':completion:*:complete:*' matcher-list 'm:{a-z}={A-Z}'

WORDCHARS=''

# Source zplug
if [[ -s ${ZDOTDIR:-${HOME}}/.zplug/init.zsh ]]; then
    source ${ZDOTDIR:-${HOME}}/.zplug/init.zsh

#    zplug "zplug/zplug"

    zplug "djui/alias-tips"
    zplug "peterhurford/git-it-on.zsh"

    zplug "mafredri/zsh-async", on:sindresorhus/pure
    zplug "sindresorhus/pure", nice:18

    BASE16_SCHEME="solarized-dark"
    zplug "chriskempson/base16-shell", use:"scripts/base16-$BASE16_SCHEME.sh", nice:-19
    zplug "chriskempson/base16-shell", use:colortest, as:command

    zplug "k4rthik/git-cal", as:command

    # setting if enhancd is available
    export ENHANCD_COMMAND=ecd
    zplug "b4b4r07/enhancd", use:init.sh

    zplug "mollifier/anyframe"

    export EMOJI_CLI_KEYBIND="^Xe"
    zplug "b4b4r07/emoji-cli"

    zplug "~/.zsh", from:local, use:"*.zsh", nice:17

    zplug "junegunn/fzf", use:"shell/*.zsh"

    zplug 'zsh-users/zaw'

    # zplug 'rupa/z'
    zplug 'knu/z', use:'z.sh', nice:10

    zplug 'NigoroJr/zaw-z', nice:11, on:'zsh-users/zaw'

    zplug "supercrabtree/k"

    zplug "plugins/golang", from:oh-my-zsh, nice:10

    zplug "zsh-users/zsh-autosuggestions", nice:10

    zplug "zsh-users/zsh-syntax-highlighting", nice:18

    zplug "zsh-users/zsh-history-substring-search", nice:19

    zplug "zsh-users/zsh-completions"

    # Install plugins if there are plugins that have not been installed
    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi

    # Then, source plugins and add commands to $PATH
    zplug load

    zstyle ':filter-select' max-lines -10
    zstyle ':filter-select' extended-search yes

    # bindkey '^R' zaw-history
    bindkey '^Xb' zaw-bookmark
    bindkey '^Xz' zaw-z

    bindkey '^T' transpose-chars
    bindkey '\ec' capitalize-word

    export FZF_COMPLETION_OPTS='+c -x'
    export FZF_DEFAULT_OPTS="--multi --inline-info"
    export FZF_CTRL_R_OPTS='--sort'

    if [ "$+commands[blsd]" -ne 0 ]; then
        export FZF_ALT_C_COMMAND=blsd

        _fzf_compgen_dir() {
            blsd "$1"
        }
    fi

    if [ "$+commands[ag]" -ne 0 ]; then
        _fzf_compgen_path() {
            ag -g "" "$1"
        }
        export FZF_DEFAULT_COMMAND='ag -g ""'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi

    bindkey '\eg' fzf-cd-widget
    bindkey '^F' fzf-file-widget
    bindkey '^I' fzf-completion



    bindkey '^]' anyframe-widget-cd-ghq-repository

    # set options
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=magenta,fg=white,bold'
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
    HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'

    # bind UP and DOWN keys
    bindkey "${terminfo[kcuu1]}" history-substring-search-up
    bindkey "${terminfo[kcud1]}" history-substring-search-down

    # bind UP and DOWN arrow keys (compatibility fallback)
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down

fi

[[ -s $HOME/.localrc ]] && source $HOME/.localrc

function rehash () {
    hash -r
    hash -rd
    [ -e $HOME/.local.hashes ] && source ~/.local.hashes || true
}

rehash


# # turn off tracing
# unsetopt xtrace
# # restore stderr to the value saved in FD 3
# exec 2>&3 3>&-
