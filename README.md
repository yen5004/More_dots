# More_dots
Dot file fun

From:
https://techguides.yt/guides/linux-server/must-know-bashrc-customizations/
https://www.youtube.com/watch?v=sruXWoWzuuQ

Must know bashrc customizations
October 31, 2023 by Roman
In this post, I show you my favourite top 10 .bashrc commands to boost efficiency when working on Linux. I have organized the commands in decreasing order of daily usage. These commands are based on more than 6 years of experience from working with Linux on a day-by-day basis, enjoy!

1. Nice Username Colors
Get more information on which machine & user you are currently logged in as well as showing the path to the current folder.

# 1. Nice username colors
export PS1='\[\e[0;36m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;35m\]\w\[\e[0m\]> '
2. Nice ls colors
Add nicer looking colors to your ls commands. This can be achieved by saving this file as .dir_colors in your $HOME directory and then adding the following line to your .bashrc file

test -r ~/.dir_colors && eval $(dircolors ~/.dir_colors)
3. Change dirs
If you’re not using ... then you’re doing it wrong 😉

# 3. Change dirs
alias ..="cd .."
alias cd..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"
4. More ls aliases
Convenient shorthand for listing files, showing hidden files, and listing files in descending order of modification together with human readable file size.

# 4. More ls aliases
alias ll='ls -l'
alias la='ls -Al'
alias lt='ls -ltrh'
5. Save copying
Never accidentally overwrite a file again with these aliases!

# 5. Save copying
alias cp='cp -vi'
alias mv='mv -vi'
6. Verbose copying
Using rsync instead of regular old cp comes with a few added perks, such as estimates for how long the copying will take and how fast the copying is currently progressing. Often also used to transfer files from one remote server to another!

# 6. Better copying
alias cpv='rsync -avh --info=progress2'
7. Define aliases
Stuff that you type on a day-by-day basis should get its own alias. You can define anything as an alias really, unless you need to pass a parameter in which case you will need to define a function (see #8 below). Here are just some ideas, go wild!

# 7. More aliases
alias bashrc="nano ~/.bashrc"
alias update="sudo -- sh -c 'apt-get update; apt-get upgrade -y; apt-get dist-upgrade -y; apt-get autoremove -y; apt-get autoclean -y'"
alias certupdate="sudo certbot certonly --manual -d *.website.com -d website.com --agree-tos --no-bootstrap --manual-public-ip-logging-ok --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory"
alias myserver="ssh -p 12345 roman@192.168.0.1"
alias count="ls * | wc -l"
alias suno="sudo nano"
alias n="nano"
alias c='clear'
8. Find string in files
You can not believe how often I’ve googled this one… Small helper function to find strings in text files

# 8. Find string in files
fstr() {
    grep -Rnw "." -e "$1"
}
9. Sudo last command
Super convenient when you forgot to issue a command with sudo. No need to rewrite the whole command or jump to the start and add a leading “sudo”, just press “s” and move on!

# 9. Sudo last command
s() { # do sudo, or sudo the last command if no argument given
    if [[ $# == 0 ]]; then
        sudo $(history -p '!!')
    else
        sudo "$@"
    fi
}
10. Easy extract
No need to remember the exact extract command and flags for different archive types, simply type “extract archive”. Source: https://github.com/xvoland/Extract

# 10. Easy extract
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
