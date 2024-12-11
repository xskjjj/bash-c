#!/bin/bash

#check if there are 2 parameters
if [[ $# -ne 2 ]]
then
	echo "Expected two input parameters."
	echo "Usage: ./deltad.bash <originaldirectory> <comparisondirectory>"
	exit 1
fi

#verify both input are directories and they are different directories
if [[ ! -d $1 ]]
then
        echo "Input parameter #1 '$1' is not a directory."
        echo "Usage: ./deltad.bash <originaldirectory> <comparisondirectory>"
        exit 2
elif [[ ! -d $2 ]]
then
        echo "Input parameter #2 '$2' is not a directory."
        echo "Usage: ./deltad.bash <originaldirectory> <comparisondirectory>"
        exit 2
elif [[ $1 -ef $2 ]]
then
        echo "Error: Same directory for both input."
        exit 2
fi

#check if both directories are empty
DIR=$1
DIR2=$2
if [ ! "$(ls -A $DIR)" ] && [ ! "$(ls -A $DIR2)" ]
then
	exit 0
fi

#iterate the directory, to find the difference
#iterate the directory, to find the difference
RETURNO=0
for FILE in $DIR/*.*
do
        if [[ ! -f $DIR2/"$(basename $FILE)" ]]
        then
                echo "$DIR2/"$(basename $FILE)" is missing"
                ((RETURNO+=1))
        else
                diff -q $FILE $DIR2/"$(basename $FILE)" > /dev/null
                if [ $? -eq 1 ]
                then
                        echo "$DIR2/"$(basename $FILE)" differs"
                        ((RETURN+=1))
                fi
        fi
done

for FILE1 in $DIR2/*.*
do
        if [[ ! -f $DIR/"$(basename $FILE1)" ]]
        then
                echo "$DIR/"$(basename $FILE1)" is missing"
                ((RETURNO+=1))
        fi
done

if [[ $RETURNO -ne 0 ]]
then
        exit 3
else
        exit 0
fi
