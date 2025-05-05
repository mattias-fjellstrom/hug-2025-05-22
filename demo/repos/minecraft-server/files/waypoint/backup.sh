#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <s3-bucket-name>"
  exit 1
fi

S3_BUCKET_NAME="$1"
DIR_TO_ARCHIVE="/home/mcserver/minecraft_java/world"
DATE_DIR=$(date +%F)
TIME_NAME=$(date +%H%M%S)
ARCHIVE_NAME="${TIME_NAME}.tar.gz"
S3_PATH="s3://${S3_BUCKET_NAME}/backups/${DATE_DIR}/"

tar -czf "$ARCHIVE_NAME" "$DIR_TO_ARCHIVE"
aws s3 cp "$ARCHIVE_NAME" "$S3_PATH"
rm "$ARCHIVE_NAME"
