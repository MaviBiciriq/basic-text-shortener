#!/usr/bin/env bash

RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
CYAN='\033[36m'
RESET='\033[0m'

while true; do
    clear
    echo "1) English"
    echo "2) Türkçe"
    echo
    read -rp "Select language / Dil seç: " lang_choice

    case "$lang_choice" in
        1)
            TITLE="Text Shortener"
            ENTER_TEXT="Enter text:"
            ENTER_PERCENT="Shortening percentage (0-100):"
            ONLY_NUMBER="Only numbers are allowed."
            PERCENT_RANGE="Warning: Percentage must be between 0 and 100."
            SELECT_MODE="Select mode:"
            MODE1="1) Word by word"
            MODE2="2) Letter by letter"
            SELECT_MODE_CHOICE="Choice (1/2):"
            INVALID_MODE="Invalid mode selected."
            ORIG="Original:"
            SHORT="Shortened:"
            END_MENU1="1) Close"
            END_MENU2="2) Restart"
            END_CHOICE="Choice:"
            EMPTY_TEXT="Text cannot be empty."
            ;;
        2)
            TITLE="Metin Kısaltıcı"
            ENTER_TEXT="Metni gir:"
            ENTER_PERCENT="Kısaltma yüzdesi (0-100):"
            ONLY_NUMBER="Sadece sayı girilmeli."
            PERCENT_RANGE="Uyarı: Yüzde 0 ile 100 arasında olmalı."
            SELECT_MODE="Mod seç:"
            MODE1="1) Kelime kelime"
            MODE2="2) Harf harfi"
            SELECT_MODE_CHOICE="Seçim (1/2):"
            INVALID_MODE="Geçersiz mod seçildi."
            ORIG="Orijinal:"
            SHORT="Kısaltılmış:"
            END_MENU1="1) Kapat"
            END_MENU2="2) Yeniden başlat"
            END_CHOICE="Seçim:"
            EMPTY_TEXT="Metin boş olamaz."
            ;;
        *)
            continue
            ;;
    esac
    break
done

shorten_text() {
    local input="$1"
    local percent="$2"
    local mode="$3"

    if [ "$mode" = "1" ]; then
        set -- $input
        local total=$#
        [ "$total" -eq 0 ] && { echo ""; return; }

        local keep=$(( total * (100 - percent) / 100 ))
        [ "$keep" -lt 1 ] && keep=1

        local out=""
        local i=0
        for w in "$@"; do
            i=$((i + 1))
            [ "$i" -le "$keep" ] && out="${out}${w} "
        done
        echo "${out% }"

    elif [ "$mode" = "2" ]; then
        local out=""
        for word in $input; do
            local len=${#word}
            [ "$len" -eq 0 ] && continue

            local keep=$(( len * (100 - percent) / 100 ))
            [ "$keep" -lt 1 ] && keep=1

            local start=$(( (len - keep) / 2 ))
            out+="${word:start:keep} "
        done
        echo "${out% }"
    else
        echo ""
    fi
}

while true; do
    clear
    echo -e "${CYAN}=== ${TITLE} ===${RESET}"
    echo

    read -rp "$ENTER_TEXT " text
    [ -z "$text" ] && { echo -e "${RED}$EMPTY_TEXT${RESET}"; exit 1; }

    read -rp "$ENTER_PERCENT " percent

    case "$percent" in
        ''|*[!0-9]*)
            echo -e "${RED}$ONLY_NUMBER${RESET}"
            exit 1
            ;;
    esac

    if [ "$percent" -lt 0 ] || [ "$percent" -gt 100 ]; then
        echo -e "${RED}$PERCENT_RANGE${RESET}"
        exit 1
    fi

    echo
    echo "$SELECT_MODE"
    echo "$MODE1"
    echo "$MODE2"
    read -rp "$SELECT_MODE_CHOICE " mode

    case "$mode" in
        1|2) ;;
        *)
            echo -e "${RED}$INVALID_MODE${RESET}"
            exit 1
            ;;
    esac

    shortened="$(shorten_text "$text" "$percent" "$mode")"

    clear
    echo -e "${GREEN}$ORIG${RESET}"
    echo "$text"
    echo
    echo -e "${YELLOW}$SHORT${RESET}"
    echo "$shortened"
    echo

    echo "$END_MENU1"
    echo "$END_MENU2"
    read -rp "$END_CHOICE " end_choice

    case "$end_choice" in
        1)
            clear
            exit 0
            ;;
        2)
            continue
            ;;
        *)
            clear
            exit 0
            ;;
    esac
done