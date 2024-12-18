#!/bin/bash

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

# Если вызыв срипта осущестляется с произвольной директории
path_filename=$0
filename=$0
delimiter="/"
# Обрезаем строку до последнего вхождения символа
path="${path_filename%$delimiter*}"
if [ "$path" = "$path_filename" ]; then
    path=""
else
    filename="${path_filename%*$delimiter}"
    path="${path}/"
fi

# Проверка количества параметров
WARNING="$filename: Предупреждение: Должно быть четыре целочисленных параметра (от 1 до 6)."
validation_check() {
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
}

# Функция для настройки цветового форматирования
set_color() {
  local text="$1"
  local bg_color="$2"
  local font_color="$3"
  echo -e "\e[${bg_color};${font_color}m${text}\e[0m"
}

# Чтение конфигурационного файла
read_config_file() {
  if [ -f "${path}config.conf" ]; then
    source "${path}config.conf"
  else
    echo "$filename: Предупреждение: файл ${path}config.conf не найден."
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

process_variables() {
  isdefault=false
  if [[ ! (-n "$column1_background" && -n "$column1_font_color" && -n "$column2_background" && -n "$column2_font_color") ]]; then
     column1_background=1
     column1_font_color=2
     column2_background=1
     column2_font_color=2
     isdefault=true
  fi
  check_parameters "$column1_background" "$column1_font_color" "$column2_background" "$column2_font_color"
  validation_check "$column1_background" "$column1_font_color" "$column2_background" "$column2_font_color"
  set_colors "$column1_background" "$column1_font_color" "$column2_background" "$column2_font_color"
  # Вывод информации о системе
  source  "${path}info.sh"
  get_system_info
  local color_names=("white" "red" "green" "blue" "purple" "black")
  local column1_bg_name="${color_names[column1_background - 1]}"
  local column1_font_name="${color_names[column1_font_color - 1]}"
  local column2_bg_name="${color_names[column2_background - 1]}"
  local column2_font_name="${color_names[column2_font_color - 1]}"

  if $isdefault; then
    column1_background="default"
    column1_font_color="default"
    column2_background="default"
    column2_font_color="default"
  fi

  echo
  echo "Column 1 background = $column1_background ($column1_bg_name)"
  echo "Column 1 font color = $column1_font_color ($column1_font_name)"
  echo "Column 2 background = $column2_background ($column2_bg_name)"
  echo "Column 2 font color = $column2_font_color ($column2_font_name)"

}

# Чтение конфигурационного файла
read_config_file

process_variables
