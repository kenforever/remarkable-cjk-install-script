@echo off
setlocal

REM 初始化變數，預設使用 root，字體 URL 設為預設值
set REMOTE_USER=root
set FONT_URL=https://github.com/lxgw/LxgwWenkaiTC/releases/download/v1.500/LXGWWenKaiMonoTC-Regular.ttf
set REMOTE_IP=
set REMOTE_PASSWORD=

REM 檢查命令列參數
:parse
if "%~1"=="" goto done
if "%~1"=="-i" (
    set REMOTE_IP=%~2
    shift
    shift
    goto parse
)
if "%~1"=="-u" (
    set REMOTE_USER=%~2
    shift
    shift
    goto parse
)
if "%~1"=="-p" (
    set REMOTE_PASSWORD=%~2
    shift
    shift
    goto parse
)
if "%~1"=="-f" (
    set FONT_URL=%~2
    shift
    shift
    goto parse
)

:done

REM 如果沒有提供 IP，則要求使用者輸入
if "%REMOTE_IP%"=="" (
    set /p REMOTE_IP=Please enter the SSH IP:
)

REM 如果沒有提供使用者名稱，則使用 root
if "%REMOTE_USER%"=="root" (
    set /p REMOTE_USER=Please enter the SSH Username (default: root):
    if "%REMOTE_USER%"=="" set REMOTE_USER=root
)

REM 如果沒有提供密碼，則要求使用者輸入（隱藏輸入）
if "%REMOTE_PASSWORD%"=="" (
    set /p REMOTE_PASSWORD=Please enter the SSH Password:
)

REM 如果沒有提供字體 URL，則詢問使用者並使用預設 URL
set /p INPUT_FONT_URL=Please enter the font URL (default: %FONT_URL%):
if not "%INPUT_FONT_URL%"=="" (
    set FONT_URL=%INPUT_FONT_URL%
)

REM 檢查 curl 是否可用
curl --version >nul 2>&1
if errorlevel 1 (
    echo Error: curl is not installed. Please install curl and try again.
    exit /b 1
)

REM 檢查 pscp 是否可用
pscp -V >nul 2>&1
if errorlevel 1 (
    echo Error: pscp is not installed. Please install pscp and try again.
    exit /b 1
)

REM 檢查 SSH 連線是否成功
echo Testing SSH connection...
echo y | pscp -pw %REMOTE_PASSWORD% -P 22 -batch nul %REMOTE_USER%@%REMOTE_IP%: /dev/null
if errorlevel 1 (
    echo Error: Unable to connect to the remote server. Please check your credentials and IP address.
    exit /b 1
)

REM 字體檔案名稱從 URL 解析
for %%A in ("%FONT_URL%") do set FONT_FILE=%%~nxA

REM 下載字體檔案到 %TEMP% 目錄
set FONT_PATH=%TEMP%\%FONT_FILE%
echo Downloading font file to %TEMP% directory from %FONT_URL%...
curl -L -o %FONT_PATH% %FONT_URL%
if errorlevel 1 (
    echo Error: Failed to download the font file. Please check the URL and network connection.
    exit /b 1
)

REM 檢查檔案是否成功下載
if not exist "%FONT_PATH%" (
    echo Error: Font file not found after download.
    exit /b 1
)

REM 使用 pscp 複製到遠端位置
echo Copying font to remote location...
pscp -pw %REMOTE_PASSWORD% -P 22 %FONT_PATH% %REMOTE_USER%@%REMOTE_IP%:/usr/share/fonts/ttf/
if errorlevel 1 (
    echo Error: Failed to copy font to the remote server.
    exit /b 1
)

REM 清理暫存檔案
del %FONT_PATH%
if errorlevel 1 (
    echo Error: Failed to remove the temporary font file.
    exit /b 1
)

echo Font successfully transferred and installed on the remote device.

REM 提示使用者是否要重啟裝置
set /p REBOOT_CHOICE=Do you want to reboot the reMarkable device now? (Y/n):
if "%REBOOT_CHOICE%"=="" set REBOOT_CHOICE=Y

if /I "%REBOOT_CHOICE%"=="Y" (
    echo Rebooting the reMarkable device...
    echo y | pscp -pw %REMOTE_PASSWORD% -P 22 -batch nul %REMOTE_USER%@%REMOTE_IP% "/sbin/reboot"
    if errorlevel 1 (
        echo Error: Failed to reboot the remote device.
        exit /b 1
    )
    echo The reMarkable device is rebooting.
) else (
    echo Reboot skipped. You can reboot the device manually later.
)

pause
