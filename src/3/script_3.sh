#!/bin/bash

# Функция для настройки цветового форматирования
set_color() {
    local text="$1"
    local bg_color="$2"
    local font_color="$3"
    echo -e "\e[${bg_color};${font_color}m${text}\e[0m"
}

# Проверка наличия дублирующихся значений
check_parameters() {
    local bg_names=$1
    local font_names=$2
    local bg_values=$3
    local font_values=$4

    if [[ $bg_names == $font_names || $bg_values == $font_values ]]; then
        echo "$0: Предупреждение: Не должны совпадать пары чисел: 1-е и 2-е; 3-е и 4-е"
        exit 1
    fi
}

# Установка цветовых переменных на основе входных параметров
set_colors() {
    local bg_names=$1
    local font_names=$2
    local bg_values=$3
    local font_values=$4
    set_clr(){
        case $1 in
        1) echo "15" ;; # White
        2) echo "196";;  # Red
        3) echo "46" ;; # Green
        4) echo "7" ;; # Blue
        5) echo "99" ;; # Purple
        6) echo "0" ;;   # Black
        esac
    }
    
    bg_names_color="48;5;$(set_clr $bg_names)"
    font_names_color="38;5;$(set_clr $font_names)"
    bg_values_color="48;5;$(set_clr $bg_values)"
    font_values_color="38;5;$(set_clr $font_values)"
}

# Если вызыв срипта осущестляется с произвольной директории
path_filename=$0
delimiter="/"
# Обрезаем строку до последнего вхождения символа
path="${path_filename%$delimiter*}"
if [ "$path" = "$path_filename" ]; then
    path=""
else
    path="${path}/"
fi



# Проверка количества параметров
WARNING="$0: Предупреждение: Должно быть четыре целочисленных параметра (от 1 до 6)."
if [ $# -ne 4 ]; then
    echo $WARNING
    exit 1
else
    # Проверка валидности параметров
    for param in "$@"; do
        if ! [[ "$param" =~ ^([+]?[1-6])$ ]]; then
            echo $WARNING
            exit 1
        fi
    done
fi

# Извлечение параметров
bg_names=$1
font_names=$2
bg_values=$3
font_values=$4

check_parameters "$bg_names" "$font_names" "$bg_values" "$font_values"

set_colors "$bg_names" "$font_names" "$bg_values" "$font_values"

source  "${path}info.sh"
print_info
