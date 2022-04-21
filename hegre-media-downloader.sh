#!/bin/bash

error="$(tput setaf 1)ERROR!$(tput sgr 0)"
success="$(tput setaf 2)SUCCESS!$(tput sgr 0)"
warning="$(tput setaf 11)WARNING!$(tput sgr 0)"

require() {
    for what in "$@"; do
        if ! (which "$what" >& /dev/null); then
            printf "%s\n $error $what is required to run this script, please install it"
            exit 1
        fi
    done
}

require curl pv screen whiptail

case "$(curl -s --max-time 2 -I https://www.hegre.com/ | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
	[23]) printf "%s\n $success Internet access works\n";;
	5) printf "%s\n $error The web proxy does not let us through\n";;
	*) printf "%s\n $error The network is down or very slow\n";;
esac

whiptail --title "Hegre Media Downloader" --msgbox "Thank you for downloading the program, after this message you will have to enter your login and the name of the file containing the list of URLs then the download will start. \nIf you find this program useful, don't forget to give a star! \n— https://github.com/baptiste313/hegre-media-downloader/" 15 60

base_urls_list=$(whiptail --inputbox "Enter the name of the file where the raw URLs are stored:" 10 60 "base_urls_list.txt" 3>&1 1>&2 2>&3)
raw_urls_list=$(whiptail --inputbox "Enter the name of the file where the list of direct media to be downloaded will be stored:" 10 60 "raw_urls_list.txt" 3>&1 1>&2 2>&3)
username=$(whiptail --inputbox "Enter your username:" 10 60 3>&1 1>&2 2>&3)
password=$(whiptail --passwordbox "Enter your password:" 10 60 3>&1 1>&2 2>&3)

clear

# Creation of raw URLs to download videos and thumbnails

create_raw_urls_to_download_videos_and_thumbnails () {
	grep -v '^ *#' < "$base_urls_list" | while IFS= read -r line; do
		curl -s "$line" | grep -v "p.hegre.com" | grep -v "cdn2.hegre.com" | grep -E '.mp4|.zip|.jpg' | grep -o "http[^ '\"]*" | sed 's/\?.*//' | awk 'NR>1' | head -n 2;
	done > "$raw_urls_list"
}

# Creation of raw URLs to download videos and not thumbnails

create_raw_urls_to_download_videos_and_not_thumbnails () {
        grep -v '^ *#' < "$base_urls_list" | while IFS= read -r line; do
                curl -s "$line" | grep -v "p.hegre.com" | grep -v "cdn2.hegre.com" | grep -E '.mp4|.zip' | grep -o "http[^ '\"]*" | sed 's/\?.*//' | awk 'NR>1' | head -n 1;
        done > "$raw_urls_list"
}

printf "%s\n $warning This can take a while depending on the number of URLs to process\n"

while [[ "$1" != "" ]]; do
	case $1 in
                "--url" )
                        url_base=$2
			printf "%s\n $success $url_base\n"
			shift
                        ;;
                "--quality" )
			printf "To-Do List\n"
                        ;;
		"--create-links" )
			if [[  $2 = "yes"  ]] ; then
				curl -s "$url_base" | grep "p.hegre.com" | cut -d "<" --output-delimiter ">" -f 2 | sed 's,a href=",https://www.hegre.com,'| sed 's/" .*/ /' > "$base_urls_list"
				printf "%s\n $success Creation of base URLs\n"
			fi
			shift
			;;
		"--thumbnail" )
			if [[  "$2" = "yes"  ]] ; then
				create_raw_urls_to_download_videos_and_thumbnails | pv
				printf "%s\n $success Creation of raw URLs to download videos and thumbnails\n"
			else
				create_raw_urls_to_download_videos_and_not_thumbnails | pv
				printf "%s\n $success Creation of raw URLs to download videos and not thumbnails\n"
			fi
			shift
			;;
                "--download" )
			whiptail --title "Hegre Media Downloader" --msgbox "— After clicking ok, a download screen will appear. You can run 'CTRL + A + D' to keep it in the background.\n— To see the list of retrieved URLs, run the command 'cat $raw_urls_list'." 10 60
                        screen -dmS download_hegre_content bash -c "wget -i $raw_urls_list -q --show-progress --user $username --password $password"
			screen -r download_hegre_content
                        ;;
		*)
			printf "\e[91m\e[1mERROR!\e[0m Invalid argument was detected!\n"
                	exit 1;
			;;
        esac
	shift
done
