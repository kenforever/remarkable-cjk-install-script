# reMarkable cjk font installing script

[en](README_en.md)

-----

reMarkable 2 的內建字體 ( ebgaramond ) 不包含任何 cjk 字元，這個腳本將會安裝一個 cjk 字體到你的 reMarkable。

這個腳本會預設安裝 [霞鶩文楷 TC](https://github.com/lxgw/LxgwWenkaiTC) 到你的 reMarkable。

## Usage

你會需要先取得你 reMarkable 的 IP 位址和 SSH 密碼。

如果你想要從 URL 安裝其他字體，你也需要提前準備好字體的 URL。

### macOS and Linux

你會需要先安裝 `sshpass`:

macOS:

```bash
brew install sshpass
``` 

Ubuntu:
```bash
sudo apt install sshpass
```

Arch:
```bash
sudo pacman -S sshpass
```

或者你使用的其他套件管理器。

從 release 頁面下載腳本，然後執行腳本:

```bash
./install_fonts_to_remarkable.sh
```

或者直接把參數帶入執行:

```bash
./install_fonts_to_remarkable.sh -i <SSH_IP> -u <SSH_USERNAME> -p <SSH_PASSWORD> -f <FONT_URL>
```

### Windows

windows 版本的腳本由 ChatGPT 4o 重新撰寫，並未經過測試，請自行承擔風險。

你會需要先安裝 `pscp`:

安裝 [putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) 並在安裝過程中選擇 `pscp`。

從 release 頁面下載腳本，然後執行腳本:

```bash
install_fonts_to_remarkable.bat
```

或者直接把參數帶入執行:

```bash
install_fonts_to_remarkable.bat -i <SSH_IP> -u <SSH_USERNAME> -p <SSH_PASSWORD> -f <FONT_URL>
```
