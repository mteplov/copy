#!/bin/bash

# Настройки
SOURCE_DIR="$HOME"                              # что бэкапим
BACKUP_DIR="/backup"                            # куда бэкапим (на удаленный сервер)
REMOTE_USER="teplov-mihail"                     # имя пользователя на сервере
REMOTE_HOST="192.168.0.105"                     # IP или хост сервера
REMOTE_BASE_DIR="$HOME/backups"                 # папка на сервере для резервных копий
MAX_BACKUPS=5                                   # количество сохраняемых копий

# Создание имени новой резервной копии
DATE=$(date +%Y-%m-%d_%H-%M-%S)
NEW_BACKUP="$REMOTE_BASE_DIR/$DATE"

# Создаем резервную копию через rsync
ssh $REMOTE_USER@$REMOTE_HOST "mkdir -p $REMOTE_BASE_DIR"
rsync -a --delete --link-dest="$REMOTE_BASE_DIR/latest" "$SOURCE_DIR/" "$REMOTE_USER@$REMOTE_HOST:$NEW_BACKUP/"

# Обновляем "latest" ссылку на новую резервную копию
ssh $REMOTE_USER@$REMOTE_HOST "rm -f $REMOTE_BASE_DIR/latest && ln -s $NEW_BACKUP $REMOTE_BASE_DIR/latest"

# Удаление старых резервных копий (сохраняем только последние $MAX_BACKUPS)
ssh $REMOTE_USER@$REMOTE_HOST "cd $REMOTE_BASE_DIR && ls -1tr | grep -v 'latest' | head -n -$MAX_BACKUPS | xargs -d '\n' rm -rf --"

echo "Резервное копирование завершено: $NEW_BACKUP"

