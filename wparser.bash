#!/bin/bash

if [[ $# -ne 1 ]]
# to check if the variable number is only one.
then
    echo "Usage ./wparser.bash <weatherdatadir>"
    exit 1
fi

if [[ ! -d $1  ]]
# to chekc if the input is a vaild directory.
then
    echo "Error! $1 is not a valid directory name" > 2
    exit 1
fi

filetofind=`find $1 -name 'weather_info_*.data'`
# find the file's name that contain the above string

function extractData()
{   f=$1
    echo "Processing sensor data set for $f"
    echo "===================================="
    echo "Year,Month,Day,Hour,TempS1,TempS1,TempS1,TempS1,TempS1,WindS1,WindS2,WindS3,WinDir"
        # first convert -and : to space,replace [data log flushed] with empty string, replace missed sync step with noinf for convience then replace the last number with corresponding letter,then split them by space, in the end separate numbers by comma
        # initiate 5 variable to store and update the value that is not 'NOINF'
    grep -r "observation line" $f | sed -e 's/-/ /' -e 's/-/ /' -e 's/:/ /' -e 's/:/ /' -e 's/\[data log flushed\]/''/g' -e 's/MISSED SYNC STEP/NOINF/g' -e 's/[0]$/N/' -e 's/[1]$/NE/' -e 's/[2]$/E/' -e 's/[3]$/SE/' -e 's/[4]$/S/' -e 's/[5]$/SW/' -e 's/[6]$/W/' -e 's/[7]$/NW/'| awk '
        BEGIN {OFS=",";t1="";t2="";t3="";t4="";t5=""}
        { if ($9 != "NOINF") {t1=$9} }
        { if ($10 != "NOINF") {t2=$10} }
        { if ($11 != "NOINF") {t3=$11} }
        { if ($12 != "NOINF") {t4=$12} }
        { if ($13 != "NOINF") {t5=$13} }
        {print $1,$2,$3,$4,t1,t2,t3,t4,t5,$14,$15,$16,$17}
        '
        echo "===================================="

        echo "Observation Summary"
        echo "Year,Month,Date,Hour,MaxTemp,MinTemp,MaxWS,MinWS"
    # this block is for finding the maximum and minimun temperature,ws.
    # compare the number one by one starts from the first one to get the max and min temp&ws.
    grep -r "observation line" $f | sed -e 's/-/ /' -e 's/-/ /' -e 's/:/ /' -e 's/:/ /' -e 's/\[data log flushed\]/''/g' -e 's/MISSED SYNC STEP/NOINF/g' | awk '
        BEGIN {OFS=",";MaxTemp=0;MinTemp=0;MaxWS=0;MinWS=0}
        { if ($9 != "NOINF" && $10 != "NOINF" && $9>$10) {MaxTemp=$9; MinTemp=$10} }
        { if ($9 != "NOINF" && $10 != "NOINF" && $9<$10) {MaxTemp=$10; MinTemp=$9} }
        { if ($11 != "NOINF" && MaxTemp < $11) {MaxTemp=$1} }
        { if ($11 != "NOINF" && MinTemp > $11) {MinTemp=$11} }
        { if ($12 != "NOINF" && MaxTemp < $12) {MaxTemp=$12} }
        { if ($12 != "NOINF" && MinTemp > $12) {MinTemp=$12} }
        { if ($13 != "NOINF" && MaxTempt < $13) {MaxTemp=$13} }
        { if ($13 != "NOINF" && MinTemp > $13) {MinTemp=$13} }
        { if ($14>$15) {MaxWS=$14; MinWS=$15} }
        { if ($15>$14) {MaxWS=$15; MinWS=$14} }
        { if ($16>MaxWS) {MaxWS=$16} }
        { if ($16<MinWS) {MinWS=$16} }
    {print $1,$2,$3,$4,MaxTemp,MinTemp,MaxWS,MinWS}
        '
    echo "===================================="   
}

for file in $filetofind
do
    #call each file in the dir
    extractData $file
done

#longstr='abcde'
longstr=$(
for f in $filetofind
do
        # replace missing data with noinf then count noinf for each temp and the total missing for the day
        grep -r 'observation line' $f | sed -e 's/-/ /' -e 's/-/ /' -e 's/:/ /' -e 's/:/ /' -e 's/\[data log flushed\]/''/g' -e 's/MISSED SYNC STEP/NOINF/g'| awk '
                BEGIN { OFS=","; t1=0;t2=0;t3=0;t4=0;t5=0; }
                {if($9=="NOINF"){t1=t1+1}}
                {if($10=="NOINF"){t2=t2+1}}
                {if($11=="NOINF"){t3=t3+1}}
                {if($12=="NOINF"){t4=t4+1}}
                {if($13=="NOINF"){t5=t5+1}}
                {print $1,$2,$3,t1,t2,t3,t4,t5,t1+t2+t3+t4+t5;}
                '
# Sort the data base on decedning order and chronological order if 2 or more dates have the same number of missing
done | sort -t "," -n -k9,9nr -k1,3)
echo $longstr
#conver the changeline by comma then split by comma into a string
newstr=$(sed -z 's/\n/,/g' <<< $longstr)

IFS="," read -r -a array <<<$newstr

HTMLSTR="<HTML><BODY><H2>Sensor error statistics</H2><TABLE>
<TR><TH>Year</TH><TH>Month</TH><TH>Day</TH><TH>TempS1</TH><TH>TempS2</TH><TH>TempS3</TH><TH>TempS4</TH><TH>TempS5</TH><TH>Total</TH>"
#for loop to store data line by line to the string
for i in ${!array[@]}
do
	#if it is the first entry of the data,make it start the line
         if [[ $i -eq 0 ]]
         then
                 HTMLSTR+="<TR><TD>"${array[i]}"<TD>"
         #if it is the first entry of the line, make it start the line
         elif ! (($i%9))
         then
                HTMLSTR+="<TR><TD>"${array[i]}"<TD>"
         #if it is the last entry of the line, make it end the line
         elif ! (( ($i+1) %9))
         then
                 HTMLSTR+="<TD>"${array[i]}"<TD></TR>"
         else
                HTMLSTR+="<TD>"${array[i]}"<TD>"
fi
done

#add the ending to the string
HTMLSTR+="</TABLE>
</BODY>
</HTML>
"

echo $HTMLSTR > sensorstats.html
