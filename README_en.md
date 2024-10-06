# reMarkable cjk font installing script

the build-in font ( ebgaramond ) for reMarkable 2 does not include any cjk characters, this script will install a cjk font to your reMarkable.

by default, the script will install [霞鶩文楷 TC](https://github.com/lxgw/LxgwWenkaiTC) to your reMarkable.

## Usage

You will need to get the IP address and SSH password of your reMarkable first.

if you want to install the font from a URL, you will also need to prepare the URL of the font.

### macOS and Linux

you will need to have `sshpass` installed first:

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

or other package manager you use.

download the script from the release page, then run the script:

```bash
./install_fonts_to_remarkable.sh
```

or directly pass the parameters to the script:

```bash
./install_fonts_to_remarkable.sh -i <SSH_IP> -u <SSH_USERNAME> -p <SSH_PASSWORD> -f <FONT_URL>
```

### Windows

The script are re-written by ChatGPT 4o, and havn't been tested yet, USE AT YOUR OWN RISK.

you will need to have `pscp` installed first:

install [putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) and select `pscp` during installation.

download the script from the release page, then run the script:

```bash
./install_fonts_to_remarkable.bat
```

or directly pass the parameters to the script:

```bash
install_fonts_to_remarkable.bat -i <SSH_IP> -u <SSH_USERNAME> -p <SSH_PASSWORD> -f <FONT_URL>
```
