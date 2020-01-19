#!/bin/bash

option=0
type1='.jpg'
type2='.png'
type3='.svg'
path=$(eval pwd)
read -p "Please input target folder path: " path
echo "you chose path $path"
read -p "Please input 1 for head change or 2 for tail change: " option
echo "you chose option $option"
read -p "Please input the words you want to add: " addon
echo "your target words is $addon"
for names in $(ls $path | (grep "$type1" || grep "$type2" || grep "$type3"))
do
	case $option in
		1) 	newhead="$addon${names%.*}"
			newtail=${names#*.}
			newnames=$newhead".$newtail";;

		2) 	newhead="${names%.*}$addon"
			newtail=${names#*.}
			newnames=$newhead".$newtail";;
	esac
	mv $path'/'$names $path'/'$newnames
done
