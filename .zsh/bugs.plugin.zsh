function cdb () {
    builtin cd "/bugs/files"`printf '%.8d' "$1" | sed 's:\(.\):/\1:g'`
}
