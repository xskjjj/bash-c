#!/bin/bash


#check if there is 2 parameter
if [[ $# -ne 2 ]]
then
	echo "Error: Expected two inpt parameters."
	echo "Usage: ./coderback.bash <backupdirectory><fileordirtobackup>"
	exit 1
fi

#check if the first input exsit as a directory
if [[ ! -d $1 ]]
then
	echo "Error: The directory '$1' does not exist."
	exit 2
fi

#check if the second input exist as a directory or a file
if [ -d $2 ] || [ -f $2 ] 
then
	:
else
	echo "Error: the directory or file '$2' does not exist."
	exit 2
fi

#check if the both input are the same directory
if [[ $1 -ef $2 ]]
then
	echo "Error: same directory for both input."
	exit 2
fi

#backup

if [[ ! -f $1/$(basename $2).$(date '+%Y%m%d').tar ]]
then
	tar -cf $(basename $2).$(date '+%Y%m%d').tar -P $2
	mv $(basename $2).$(date '+%Y%m%d').tar $1
else
	echo "Backup file '"$2.$(date '+%Y%m%d').tar"' already exists. Overwrite? (y/n)"
	read -p "Backup file '"$2.$(date '+%Y%m%d').tar"' already exists. Overwrite? (y/n)" CHOICE
	if [ "$CHOICE" = "y" ]
	then
		tar -cf $(basename $2).$(date '+%Y%m%d').tar -P $2
		mv -f  $(basename $2).$(date '+%Y%m%d').tar $1
		exit 0
	else
		exit 3
	fi

fi

