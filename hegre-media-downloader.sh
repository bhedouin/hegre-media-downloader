#!/bin/bash

whiptail --title "Hegre Media Downloader" --msgbox "Thank you for downloading the program, after this message you will have to enter your login and the name of the file containing the list of URLs then the download will start. \nIf you find this program useful, don't forget to give a star! \n— https://github.com/baptiste313/hegre-video-downloader/" 15 60

INDEX=$(whiptail --inputbox "Enter the url with an index of content to download, or leave blank if you have a custom list of content to download:" 10 60 "https://www.hegre.com/search?year=2022" 3>&1 1>&2 2>&3)
FILE=$(whiptail --inputbox "Enter the name of the file where the raw URLs are stored:" 10 60 "2022.txt" 3>&1 1>&2 2>&3)
OUTPUT=$(whiptail --inputbox "Enter the name of the file where the list of direct media to be downloaded will be stored:" 10 60 "file_to_download.txt" 3>&1 1>&2 2>&3)
USER=$(whiptail --inputbox "Enter your username:" 10 60 3>&1 1>&2 2>&3)
PASSWORD=$(whiptail --passwordbox "Enter your password:" 10 60 3>&1 1>&2 2>&3)

clear

printf "This can take some time depending on the number of URLs to process\n"

create_hegre_links () {
     curl -s "$INDEX" | grep "p.hegre.com" | cut -d "<" --output-delimiter ">" -f 2 |sed 's,a href=",https://www.hegre.com,'|sed 's/" .*/ /' > "$FILE"
}

time create_hegre_links

get_the_hegre_links () {
    for line in $(cat "$FILE");
    do
      curl -s "$line" | grep -v "p.hegre.com" | grep -v "cdn2.hegre.com" | grep -E '.mp4|.zip|.jpg' | grep -o "http[^ '\"]*" | sed 's/\?.*//' | awk 'NR>1' | head -n 2;
    done > "$OUTPUT"
}

time get_the_hegre_links

whiptail --title "Hegre Media Downloader" --msgbox "— After clicking ok, a download screen will appear. You can run 'CTRL + A + D' to keep it in the background.\n— To see the list of retrieved urls, run the command 'cat $OUTPUT'." 10 60

screen -dmS download_hegre_content bash -c "wget -i $OUTPUT -q --show-progress --user $USER --password $PASSWORD --no-clober"

screen -r download_hegre_content
