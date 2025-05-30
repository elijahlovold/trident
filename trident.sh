# ,--------.       ,--.   ,--.                 ,--.   
# '--.  .--',--.--.`--' ,-|  | ,---. ,--,--, ,-'  '-. 
#    |  |   |  .--',--.' .-. || .-. :|      \'-.  .-' 
#    |  |   |  |   |  |\ `-' |\   --.|  ||  |  |  |   
#    `--'   `--'   `--' `---'  `----'`--''--'  `--'   

trident() {
    [ ! -n "$TRIDENT_JUMP_FILE" ] && TRIDENT_JUMP_FILE="${XDG_CACHE_HOME:-$HOME}/trident"
    VERSION=1.0.1

    case "$1" in
        jump|-j)
            dir=$(sed -n "${2}p" "$TRIDENT_JUMP_FILE")
            if [ -d "$dir" ]; then
                cd $dir
            elif [ -f "$dir" ]; then
                $EDITOR $dir 
            fi
            ;;
        add|-a)
            file="$(pwd)/$2"
            if [ -f "$file" ]; then
                echo "Trident - adding file: $file"
                echo "$file" >> "$TRIDENT_JUMP_FILE"
            else 
                echo "Trident - adding dir: $(pwd)/"
                echo "$(pwd)/" >> "$TRIDENT_JUMP_FILE"
            fi
            ;;
        edit|-e) 
            eval "$EDITOR $TRIDENT_JUMP_FILE"
            ;;
        list|-l) 
            cat "$TRIDENT_JUMP_FILE"
            ;;
        help|--help|-h)
            echo "Usage: trident <command> [arguments]"
            echo "Commands:"
            echo "  jump, -j <0-9>  - Jump to the specified directory or file."
            echo "  add, -a [file]  - Add the file or current dir if none."
            echo "  edit, -e        - Edit jump list."
            echo "  list, -l        - Show jump list."
            echo "  help, -h        - Show this message."
            echo "  version, -v     - Show version."
            ;;
        version|-v) 
            echo "$VERSION"
            ;;
        *)
            echo "Invalid option. Use 'trident help' for usage."
            ;;
    esac
}

# completion
_trident_completions() {
    local cur prev options
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    options="jump add edit list help version"

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "$options" -- "$cur") )
    elif [["$prev" == "add" || "$prev" == "-a"]]; then
        COMPREPLY=( $(compgen -d -- "$cur") )  # Suggest directories for jump and add
    fi
}

if [[ -n "$BASH_VERSION" ]]; then
    complete -F _trident_completions trident
    # If we're in Bash, use bind
    bind '"\e1":"\C-utrident jump 1\n"'
    bind '"\e2":"\C-utrident jump 2\n"'
    bind '"\e3":"\C-utrident jump 3\n"'
    bind '"\e4":"\C-utrident jump 4\n"'
    bind '"\e5":"\C-utrident jump 5\n"'
    bind '"\e6":"\C-utrident jump 6\n"'
    bind '"\e7":"\C-utrident jump 7\n"'
    bind '"\e8":"\C-utrident jump 8\n"'
    bind '"\e9":"\C-utrident jump 9\n"'
    bind '"\e0":"\C-utrident jump 10\n"'

    bind '"\ea":"\033[Htrident add \n"'

    bind -x '"\C-e" : trident "edit"'

elif [[ -n "$ZSH_VERSION" ]]; then
    # If we're in Zsh, use bindkey
    bindkey -s '^[1' '^Utrident jump 1\n'
    bindkey -s '^[2' '^Utrident jump 2\n'
    bindkey -s '^[3' '^Utrident jump 3\n'
    bindkey -s '^[4' '^Utrident jump 4\n'
    bindkey -s '^[5' '^Utrident jump 5\n'
    bindkey -s '^[6' '^Utrident jump 6\n'
    bindkey -s '^[7' '^Utrident jump 7\n'
    bindkey -s '^[8' '^Utrident jump 8\n'
    bindkey -s '^[9' '^Utrident jump 9\n'
    bindkey -s '^[0' '^Utrident jump 10\n'

    bindkey -s '^[a' '^Utrident add \n'
    bindkey -s '^e' '^Utrident edit\n'
fi
