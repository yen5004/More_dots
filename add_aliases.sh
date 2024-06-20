#!/bin/bash
# Use this script to add functional dots to bashrc

# define the aliases to be added
aliases=$(cat << 'EOF'

####### Addition of custom scripts #######
####### Addition of custom scripts #######
####### Addition of custom scripts #######

# Change dirs
alias ..="cd .."
alias cd..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"

# CD and ls
alias up='cd .. && ls -la'
alias ups='cd .. && ls -ls'
alias uph='cd .. && ls -lh'

# More ls aliases
# Convenient shorthand for listing files, showing hidden files, and listing files in descending order of modification together with human readable file size.
alias ll='ls -l'
alias la='ls -Al'
alias lt='ls -ltrh'

# Save copying
alias cp='cp -vi'
alias mv='mv -vi'

# Better copying
alias cpv='rsync -avh --info=progress2'

# More aliases
alias bashrc="nano ~/.bashrc"
alias zshrc="nano ~/.zshrc"
alias update="sudo -- sh -c 'sudo apt-get update -y; apt-get upgrade -y; apt-get dist-upgrade -y; apt-get autoremove -y; apt-get autoclean -y'"
alias certupdate="sudo certbot certonly --manual -d *.website.com -d website.com --agree-tos --no-bootstrap --manual-public-ip-logging-ok --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory"
alias count='ls * | wc -l'
alias suno='sudo nano'
alias n='nano'
alias c='clear'

# Find string in files
fstr() {
    grep -Rnw "." -e "$1"
}

# Sudo last command
s() { # do sudo, or sudo the last command if no argument is given
    if [[ $# == 0 ]]; then
        sudo $(history -p '!!')
    else
        sudo "$@"
    fi
}

# Easy extract
function extract {
 if [ $# -eq 0 ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz|.zlib|.cso|.zst>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 fi
    for n in "$@"; do
        if [ ! -f "$n" ]; then
            echo "'$n' - file doesn't exist"
            return 1
        fi

        case "${n%,}" in
          *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                       tar zxvf "$n"       ;;
          *.lzma)      unlzma ./"$n"      ;;
          *.bz2)       bunzip2 ./"$n"     ;;
          *.cbr|*.rar) unrar x -ad ./"$n" ;;
          *.gz)        gunzip ./"$n"      ;;
          *.cbz|*.epub|*.zip) unzip ./"$n"   ;;
          *.z)         uncompress ./"$n"  ;;
          *.7z|*.apk|*.arj|*.cab|*.cb7|*.chm|*.deb|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar|*.vhd)
                       7z x ./"$n"        ;;
          *.xz)        unxz ./"$n"        ;;
          *.exe)       cabextract ./"$n"  ;;
          *.cpio)      cpio -id < ./"$n"  ;;
          *.cba|*.ace) unace x ./"$n"     ;;
          *.zpaq)      zpaq x ./"$n"      ;;
          *.arc)       arc e ./"$n"       ;;
          *.cso)       ciso 0 ./"$n" ./"$n.iso" && \
                            extract "$n.iso" && \rm -f "$n" ;;
          *.zlib)      zlib-flate -uncompress < ./"$n" > ./"$n.tmp" && \
                            mv ./"$n.tmp" ./"${n%.*zlib}" && rm -f "$n"   ;;
          *.dmg)
                      hdiutil mount ./"$n" -mountpoint "./$n.mounted" ;;
          *.tar.zst)  tar -I zstd -xvf ./"$n"  ;;
          *.zst)      zstd -d ./"$n"  ;;
          *)
                      echo "extract: '$n' - unknown archive method"
                      return 1
                      ;;
        esac
    done
}

# Grep function example: grepa test (word to search for)
grepa() { # ls -la | grep with a function passed
    ls -la |grep "$1"
}

# Grep function example: greps test (word to search for)
greps() { # ls -ls | grep with a function passed
    ls -ls |grep "$1"
}

# Grep function example: greph test (word to search for)
greph() { # ls -la | grep with a function passed
    ls -lh |grep "$1"
}

# cd to a folder passed as a function and ls -la
cda() { # cd && ls -la with a function passed
    cd "$1" && ls -la
}

# cd to a folder passed as a function and ls -ls
cds() { # cd && ls -ls with a function passed
    cd "$1" && ls -ls
}

# cd to a folder passed as a function and ls -lh
cdh() { # cd && ls -lh with a function passed
    cd "$1" && ls -lh
}

# Used when using a ntfy server
ntfy(){
curl -d "$1" notify.addy/room
}

alias cheatdir='cd ~/.config/cheat/cheatsheets/personal'
alias cheat_help='cd ~/.config/cheat/cheatsheets/personal'

EOF
)

# Append the aliases to .bashrc & resource .bashrc to apply changes
# echo "$aliases" >> ~/.bashrc
# source ~/.bashrc
# echo "Aliases added and .bashrc sourced successfully."

# Append the aliases to .zshrc & resource .zshrc to apply changes
echo "$aliases" >> ~/.zshrc # for kali machines
source ~/.zshrc # for kali machines
echo "Aliases added and .zshrc sourced successfully."
