#!/bin/bash

DOWNLOAD_DIR="wget_files"

#(src: https://sentry.io/answers/determine-whether-a-directory-exists-in-bash/)
if [ ! -d "$DOWNLOAD_DIR" ]; then
    mkdir "$DOWNLOAD_DIR"
fi

URLS=(
"https://cdn.pixabay.com/photo/2024/09/27/15/20/halloween-9079096_1280.jpg"
"https://cdn.pixabay.com/photo/2020/09/23/19/58/halloween-5596921_1280.jpg"
"https://example-files.online-convert.com/document/pdf/example.pdf"
"https://example-files.online-convert.com/document/txt/example.txt"
"https://example-files.online-convert.com/audio/mp3/example.mp3"
)


for URL in "${URLS[@]}"; do
   
	FILE=$(basename "$URL")
	FILE_PATH="$DOWNLOAD_DIR/$FILE" 

	if [ -f "$FILE_PATH" ]; then
		echo "File '$FILE' exists, indicating as changed."
		echo "You may check stat '$FILE' for details."
	else
    echo "File '$FILE' does not exist, downloading."
	fi

	#(src: man wget and https://www.ninjaone.com/script-hub/how-to-download-files-from-urls-with-a-bash-script/)
	if wget -q  -O "$FILE_PATH" "$URL"; then
		echo "Succesfully downloaded '$FILE'."
	else
		echo "Something went wrong downloading '$FILE'."
	fi

done
