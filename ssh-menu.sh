#!/bin/bash

selected_item=0
menu_items=(
    "ssh lab"
    "ssh gpu"
    "code gpu ~/ksy"
    "code gpu ~/ksy-fake_vs"
    "code gpu ~/ksy-gramschmidt"
    "code gpu ~/ksy-cuda-snippets"
    "ssh inuiyeji"
    "code gpu ~/ksy-music"
)

connection_commands=(
    'ssh lab'
    'ssh gpu'
    'code --folder-uri vscode-remote://ssh-remote+gpu/home/user01/ksy'
    'code --folder-uri vscode-remote://ssh-remote+gpu/home/user01/ksy-fake_vs'
    'code --folder-uri vscode-remote://ssh-remote+gpu/home/user01/ksy-gramschmidt'
    'code --folder-uri vscode-remote://ssh-remote+gpu/home/user01/ksy-cuda-snippets'
    'ssh swji.skku.edu -p 1398 -l 2016314695'
    'code --folder-uri vscode-remote://ssh-remote+gpu/home/user01/ksy-music'
)

menu_size=${#menu_items[@]}

print_menu() {
    clear

    for ((i = 0; i < $menu_size; ++i)); do
        if [ $i = $selected_item ]; then
            echo "-> ${menu_items[i]}"
        else
            echo "   ${menu_items[i]}"
        fi
    done
}

run_menu() {
    print_menu

    while read -rsn1 input; do
        case $input in
        $'\x1B')
            read -rsn1 -t 0.1 input
            if [ $input = "[" ]; then
                read -rsn1 -t 0.1 input
                case $input in
                A)
                    if [ $selected_item -ge 1 ]; then
                        selected_item=$((selected_item - 1))
                    else
                        selected_item=$((menu_size - 1))
                    fi
                    ;;
                B)
                    if [ $selected_item -lt $((menu_size - 1)) ]; then
                        selected_item=$((selected_item + 1))
                    else
                        selected_item=0
                    fi
                    ;;
                esac
                print_menu
            fi
            read -rsn5 -t 0.1
            ;;
        "")
            clear
            return $selected_item
            ;;
        esac
    done
}

selection_menu() {
    run_menu
    menu_result=$?

    eval ${connection_commands[$menu_result]}
}

selection_menu
