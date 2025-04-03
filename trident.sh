:'

,--------.       ,--.   ,--.                 ,--.   
'--.  .--',--.--.`--' ,-|  | ,---. ,--,--, ,-'  '-. 
   |  |   |  .--',--.' .-. || .-. :|      \'-.  .-' 
   |  |   |  |   |  |\ `-' |\   --.|  ||  |  |  |   
   `--'   `--'   `--' `---'  `----'`--''--'  `--'   

 '

trident() {
    local JUMP_FILE=~/.trident
    local VERSION=1.0

    case "$1" in
        jump|-j)
            local dir
            dir=$(sed -n "${2}p" "$JUMP_FILE")
            if [ -d "$dir" ]; then
                cd $dir
            elif [ -f "$dir" ]; then
                $EDITOR $dir 
            fi
            ;;
        add|-a)
            local file="$(pwd)/$2"

            if [ -f "$file" ]; then
                echo "Trident - adding file: $file"
                echo "$file" >> "$JUMP_FILE"
            else 
                echo "Trident - adding dir: $(pwd)/"
                echo "$(pwd)/" >> "$JUMP_FILE"
            fi
            ;;
        edit|-e) 
            eval "$EDITOR $JUMP_FILE"
            ;;
        list|-l) 
            cat "$JUMP_FILE"
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

complete -F _trident_completions trident

# bindings
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

