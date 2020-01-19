#!/bin/bash

type1='.jpg'
watermark=''
read -p "Please input target folder path: " path
echo "you chose path $path"
read -p "Please input watermark words: " watermark
echo "you input watermark $watermark"

if [ -d "$path"];then
	for imgs in $(ls $path | grep "$type1")
	do
		convert -fill white -pointsize 24 -draw "text 10,15 $watermark " $imgs $imgs 
	done
else
        echo "$folderPath not exists"
fi
