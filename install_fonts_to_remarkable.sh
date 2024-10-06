#!/bin/bash

# 開啟錯誤處理，當任何命令失敗時退出腳本
set -e

# 初始化變數，將 REMOTE_USER 預設為 root，字體 URL 設為預設值
REMOTE_IP=""
REMOTE_USER="root"
REMOTE_PASSWORD=""
FONT_URL="https://github.com/lxgw/LxgwWenkaiTC/releases/download/v1.500/LXGWWenKaiMonoTC-Regular.ttf"

# 使用 getopts 來處理命令列參數
while getopts "i:u:p:f:" opt; do
  case ${opt} in
    i )
      REMOTE_IP=$OPTARG
      ;;
    u )
      REMOTE_USER=$OPTARG
      ;;
    p )
      REMOTE_PASSWORD=$OPTARG
      ;;
    f )
      FONT_URL=$OPTARG
      ;;
    \? )
      echo "Usage: ./install_fonts_to_remarkable.sh -i <SSH_IP> -u <SSH_USERNAME> -p <SSH_PASSWORD> -f <FONT_URL>"
      exit 1
      ;;
  esac
done

# 如果沒有提供 IP，則要求使用者輸入
if [ -z "$REMOTE_IP" ]; then
    read -p "Please enter the SSH IP: " REMOTE_IP
fi

# 如果在命令列參數中未提供使用者名稱，則提示用戶輸入，並使用預設值 root
if [ "$REMOTE_USER" == "root" ]; then
    read -p "Please enter the SSH Username (default: root): " INPUT_USER
    if [ -n "$INPUT_USER" ];then
        REMOTE_USER=$INPUT_USER
    fi
fi

# 如果沒有提供密碼，則要求使用者輸入（隱藏）
if [ -z "$REMOTE_PASSWORD" ]; then
    read -sp "Please enter the SSH Password: " REMOTE_PASSWORD
    echo
fi

# 如果沒有提供字體 URL，則提示使用者輸入，並使用預設字體 URL
if [ "$FONT_URL" == "https://github.com/lxgw/LxgwWenkaiTC/releases/download/v1.500/LXGWWenKaiMonoTC-Regular.ttf" ]; then
    read -p "Please enter the font URL (default: $FONT_URL): " INPUT_FONT_URL
    if [ -n "$INPUT_FONT_URL" ]; then
        FONT_URL=$INPUT_FONT_URL
    fi
fi

# 檢查 curl 是否可用
if ! command -v curl &> /dev/null; then
    echo "Error: curl is not installed. Please install curl and try again."
    exit 1
fi

# 檢查 sshpass 是否可用
if ! command -v sshpass &> /dev/null; then
    echo "Error: sshpass is not installed. Please install sshpass and try again."
    exit 1
fi

# 檢查 SCP 連線是否成功
echo "Testing SSH connection..."
sshpass -p "$REMOTE_PASSWORD" ssh -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_IP" exit
if [ $? -ne 0 ]; then
    echo "Error: Unable to connect to the remote server. Please check your credentials and IP address."
    exit 1
fi

# 字體檔案位置
FONT_FILE="/tmp/$(basename $FONT_URL)"

echo "Downloading font file to /tmp directory from $FONT_URL..."
curl -L -o $FONT_FILE $FONT_URL
if [ $? -ne 0 ]; then
    echo "Error: Failed to download the font file. Please check the URL and network connection."
    exit 1
fi

# 檢查是否成功下載字體檔案
if [ ! -f "$FONT_FILE" ]; then
    echo "Error: Font file not found after download."
    exit 1
fi

# 複製到遠端位置
echo "Copying font to remote location..."
sshpass -p "$REMOTE_PASSWORD" scp $FONT_FILE "$REMOTE_USER@$REMOTE_IP:/usr/share/fonts/ttf/"
if [ $? -ne 0 ]; then
    echo "Error: Failed to copy font to the remote server."
    exit 1
fi

# 清理下載的字體檔案
rm $FONT_FILE
if [ $? -ne 0 ]; then
    echo "Error: Failed to remove the temporary font file."
    exit 1
fi

echo "Font successfully transferred and installed on the remote device."

# 提示使用者是否要重啟裝置
read -p "Do you want to reboot the reMarkable device now? (Y/n): " REBOOT_CHOICE

REBOOT_CHOICE=${REBOOT_CHOICE:-Y}

if [ "$REBOOT_CHOICE" == "y" ] || [ "$REBOOT_CHOICE" == "Y" ]; then
    echo "Rebooting the reMarkable device..."
    sshpass -p "$REMOTE_PASSWORD" ssh -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_IP" '/sbin/reboot'
    if [ $? -ne 0 ]; then
        echo "Error: Failed to reboot the remote device."
        exit 1
    fi
    echo "The reMarkable device is rebooting."
else
    echo "Reboot skipped. You can reboot the device manually later."
fi
