bindkey -e
bindkey '^[e' expand-cmd-path
bindkey '^[^I' reverse-menu-complete
bindkey '^X^N' accept-and-infer-next-history
bindkey '^[p' history-beginning-search-backward
bindkey '^[n' history-beginning-search-forward
bindkey '^[P' history-beginning-search-backward
bindkey '^[N' history-beginning-search-forward
bindkey '^I' complete-word
# bindkey '^Xi' incremental-complete-word
# bindkey '^Xa' all-matches
# bindkey '^Xm' force-menu

if zmodload zsh/deltochar >&/dev/null; then
    bindkey '^[z' zap-to-char
    bindkey '^[Z' delete-to-char
fi

# Fix weird sequence that rxvt produces
bindkey -s '^[[Z' '\t'

bindkey -s '^|l' " | less"                           # c-| l  pipe to less
bindkey -s '^|g' ' | grep ""^[OD'                    # c-| g  pipe to grep
bindkey -s '^|a' " | awk '{print $}'^[OD^[OD"        # c-| a  pipe to awk
bindkey -s '^|s' ' | sed -e "s///g"^[OD^[OD^[OD^[OD' # c-| s  pipe to sed
bindkey -s '^|w' " | wc -l"                          # c-| w  pipe to wc

insert-root-prefix () {
   local prefix
   case $(uname -s) in
      "SunOS")
         prefix="pfexec"
      ;;
      *)
         prefix="sudo"
      ;;
   esac
   BUFFER="$prefix $BUFFER"
   CURSOR=$(($CURSOR + $#prefix + 1))
}

zle -N insert-root-prefix
bindkey "^Xf" insert-root-prefix

autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line
