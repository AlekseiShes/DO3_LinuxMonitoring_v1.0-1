#!/bin/bash

info(){
    HOSTNAME=$(hostname) # Получение информации о хосте
    # Получение информации о временной зоне
    TIMEZONE=$(timedatectl show --property=Timezone --value)
    TIMEZONE_OFFSET=$(date +'%:::z')
    USER=$(whoami) # Получение информации о пользователе
    OS=$(lsb_release -ds) # Получение информации об операционной системе
    DATE=$(date +"%d %B %Y %T") # Получение информации о текущей дате и времени
    # Получение информации о времени работы системы
    UPTIME=$(uptime -p)
    UPTIME_SEC=$(cat /proc/uptime | awk '{print $1}')
    IP=$(hostname -I | awk '{print $1}') # Получение IP-адреса
    # Получение информации о сетевой маске
    # MASK=$(ip -o -f inet addr show | awk '/scope global/ {print $4}')
    MASK=$(netstat -rn | awk 'NR==4{print $3}')
    GATEWAY=$(ip route | awk '/default/ {print $3}') # Получение IP шлюза по умолчанию
    # Получение информации о памяти
    RAM_TOTAL=$(free -b | awk '/Mem:/ {printf "%.3f GB", $2/(1024^3)}')
    RAM_USED=$(free -b | awk '/Mem:/ {printf "%.3f GB", $3/(1024^3)}')
    RAM_FREE=$(free -b | awk '/Mem:/ {printf "%.3f GB", $4/(1024^3)}')
    # Получение информации о корневом разделе
    SPACE_ROOT=$(df -BM / | awk '/\// {printf "%.2f MB", $2}')
    SPACE_ROOT_USED=$(df -BM / | awk '/\// {printf "%.2f MB", $3}')
    SPACE_ROOT_FREE=$(df -BM / | awk '/\// {printf "%.2f MB", $4}')
    # Вывод информации на экран
    echo "HOSTNAME = \t$HOSTNAME"
    echo "\nTIMEZONE = \t$TIMEZONE UTC $TIMEZONE_OFFSET"
    echo "\nUSER = \t\t$USER"
    echo "\nOS = \t\t$OS"
    echo "\nDATE = \t\t$DATE"
    echo "\nUPTIME = \t$UPTIME"
    echo "\nUPTIME_SEC = \t$UPTIME_SEC seconds"
    echo "\nIP = \t\t$IP"
    echo "\nMASK = \t\t$MASK"
    echo "\nGATEWAY = \t$GATEWAY"
    echo "\nRAM_TOTAL = $RAM_TOTAL"
    echo "\nRAM_USED = $RAM_USED"
    echo "\nRAM_FREE = $RAM_FREE"
    echo "\nSPACE_ROOT = \t$SPACE_ROOT"
    echo "\nSPACE_ROOT_USED = $SPACE_ROOT_USED"
    echo "\nSPACE_ROOT_FREE = $SPACE_ROOT_FREE"
}

RESULT=$(info) # Результат записываем во временную переменную
echo -e $RESULT # -e для замены \n \t  на непачтные знаки
read -p "$0: Записать данные в файл? (Y/N): " answer

if [[ $answer == "Y" || $answer == "y" ]]; then
	# Форматирование текущей даты и времени для имени файла
	FILENAME="$(date +"%d_%m_%y_%H_%M_%S").status"
	echo -e $RESULT > "$FILENAME" # Создание файла и запись информации
	echo "$0: Данные записаны в файл $(pwd) $FILENAME."
else
	echo "$0: Данные не записаны в файл."
fi
