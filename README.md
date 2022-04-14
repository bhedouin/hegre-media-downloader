![Contributors](https://img.shields.io/github/contributors/ZMarkC/hegre-media-downloader.svg?style=for-the-badge)](https://github.com/ZMarkC/hegre-media-downloader/graphs/contributors) [![Issues](https://img.shields.io/github/issues/ZMarkC/hegre-media-downloader.svg?style=for-the-badge)](https://github.com/ZMarkC/hegre-media-downloader/issues) [![Stargazers](https://img.shields.io/github/stars/ZMarkC/hegre-media-downloader.svg?style=for-the-badge)](https://github.com/ZMarkC/hegre-media-downloader/stargazers) [![Forks](https://img.shields.io/github/forks/ZMarkC/hegre-media-downloader.svg?style=for-the-badge)](https://github.com/ZMarkC/hegre-media-downloader/network/members) [![Apache License 2.0](https://img.shields.io/github/license/ZMarkC/hegre-media-downloader.svg?style=for-the-badge)](https://github.com/ZMarkC/hegre-media-downloader/blob/master/LICENSE)

# Hegre Media Downloader
   
Hegre Media Downloader allows you to download a list of contents by providing a file containing a list of URLs.

## Getting Started

This tool is distributed for educational purposes, and we are not responsible for any abuse that may occur.

### Prerequisites

1. First, decide what content you want to download. You can download single items, a list of items, a whole year, or the whole site.

Example URLS:
[All Movies](https://www.hegre.com/movies) 
[All Galleries](https://www.hegre.com/photos)
[All 2022](https://www.hegre.com/?types=&year=2022)
[All 2022 Galleries](https://www.hegre.com/?types=Gallery&year=2022)
[All 2020 Movies](https://www.hegre.com/?types=Films&year=2022)
[Search Results](https://www.hegre.com/search?q=beach)
[Search Results, Film Only](https://www.hegre.com/search?q=beach&types=Film)

If you have a custom list, add it to a text file in the same directory as the script. 

All content from 2022 will be added to 2022.txt and a list of media will be added to files-to-download.txt if you don't edit the defaults.


2. When you are done, you need to go to your terminal and download the dependency if you haven't already done so.

```bash
sudo apt install screen whiptail wget curl sed grep
```

## Usage

To use this tool, simply download the script and follow these steps.

```bash
wget https://github.com/ZMarkC/hegre-media-downloader/raw/main/hegre-media-downloader.sh
```

```bash
chmod +x hegre-media-downloader.sh
```

```bash
bash hegre-media-downloader.sh
```

In the default configuration, the script also fetches the thumbnails.

If you need, the images are the same name as the video file you can use its two commands after the end of the download.

```bash
for line in *.mp4; do printf "%s\n" "$line"; done | sed 's/.mp4/.jpg/' > new_name.txt
```

```bash
paste -d' ' <(ls *.jpg) new_name.txt | xargs -n2 echo
```

## Contributing

If you have a suggestion that would make this better, please fork the repo and create a pull request. Don't forget to give the project a star! Thanks again!

## Acknowledgments

- <https://unix.stackexchange.com/a/152669>
