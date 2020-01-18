#!/bin/bash

maxSize='1024'
type1='.jpg'
path=$(eval pwd)

read -p "Please input target folder path: " path
echo "you chose path $path"

if [ -d "$path"];then
	for imgs in $(ls $path | grep "$type1")
	do
		a=$(du $imgs)
		crtSize=${a%	*}
		if [ $crtSize -gt $maxSize ];then
			echo $imgs
			mogrify -resize 50% $imgs
		fi
	done
else
        echo "$folderPath not exists"
fi
		

