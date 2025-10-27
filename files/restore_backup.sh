#!/bin/bash

# Настройки
REMOTE_USER="teplov-mihail"
REMOTE_HOST="192.168.0.105"
REMOTE_BASE_DIR="$HOME/backups"  # Путь к резервным копиям на сервере
RESTORE_DIR="$HOME"              # Куда восстанавливаем

# Получаем список доступных резервных копий
echo "Доступные резервные копии на сервере $REMOTE_HOST:"
ssh $REMOTE_USER@$REMOTE_HOST "ls -1 $REMOTE_BASE_DIR"

# Пользователь выбирает копию
read -p "Введите имя резервной копии для восстановления: " SELECTED_BACKUP

# Подтверждение
echo "Восстановление из $SELECTED_BACKUP в $RESTORE_DIR"
read -p "Продолжить? Это перезапишет файлы в $RESTORE_DIR! (y/n): " CONFIRM

if [[ "$CONFIRM" != "y" ]]; then
    echo "Восстановление отменено."
    exit 1
fi

# Восстановление через rsync
rsync -av --progress "$REMOTE_USER@$REMOTE_HOST:$REMOTE_BASE_DIR/$SELECTED_BACKUP/" "$RESTORE_DIR/"

echo "Восстановление завершено."

