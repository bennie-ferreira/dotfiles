#!/bin/bash

export DISPLAY=:0
export XAUTHORITY="$HOME/.Xauthority"

icon_for() {
    case "$1" in
        brave-browser) echo "󰖟";; 
        geany) echo "󰏫";;  
        code|code-oss) echo " ";; 
        spotify) echo "󰎈" ;; 
        slack) echo "󰒲" ;; 
        telegram) echo "󰇘" ;; 
        alacritty|xterm|urxvt) echo "󰓩" ;;
        nautilus|thunar|nemo|pcmanfm) echo "󰉋" ;; 
        discord) echo "󰙯" ;;
        vlc) echo "󰕾" ;;
        steam) echo "󰓓" ;;
        *) echo "󰊠" ;;
    esac
}

out=""
while IFS= read -r line; do
    win_id=$(echo "$line" | awk '{print $1}')
    title=$(echo "$line" | cut -d' ' -f4-)

    if [[ "$title" == *"polybar-"* ]]; then
        continue
    fi

    wm_class=$(xprop -id "$win_id" WM_CLASS 2>/dev/null | cut -d '"' -f4 | tr '[:upper:]' '[:lower:]')

    icon=$(icon_for "$wm_class")

    # Usar printf para interpretar os escapes Unicode
    out+="%{A1:xdotool windowactivate $win_id:}$(printf "$icon ")%{A}"
done < <(wmctrl -l)

echo "$out"
