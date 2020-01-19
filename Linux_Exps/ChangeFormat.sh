#!/bin/bash

option=0
type1='.jpg'
type2='.png'
type3='.svg'
path=$(eval pwd)
read -p "Please input target folder path: " path
echo "you chose path $path"

if [ -d "$path"];then
	for imgs in $(ls $path | ( grep "$type2" || grep "$type3"))
	do
		convert $imgs ${file%%.*}.jpg
	done
else
        echo "$folderPath not exists"
fi
