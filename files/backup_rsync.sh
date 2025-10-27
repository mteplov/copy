#!/bin/bash
# Резервное копирование домашней директории пользователя

SRC="/home/$USER/"
DEST="/tmp/backup/"
LOGFILE="/home/$USER/backup_rsync.log"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting backup..." | tee -a "$LOGFILE"

# Запуск rsync, вывод в терминал и запись в лог
if rsync -av --delete --checksum --exclude='.*' "$SRC" "$DEST" 2>&1 | tee -a "$LOGFILE"; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Резервное копирование выполнено успешно." | tee -a "$LOGFILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Резервное копирование ошибка!" | tee -a "$LOGFILE"
fi

