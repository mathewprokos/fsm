#!/bin/sh

FILE=$1
DOT=$2

find_replace() {
    if [ -e $DOT ]
    then
        sed "s/\(label.*=.*\)$1/\1$2/" < $DOT > $DOT.tmp
        mv $DOT.tmp $DOT
    fi
}

while read LINE
do
    HAS_EQ=`echo $LINE | grep =`
    echo "line $LINE"
    echo "cmd $HAS_EQ"
    if [ 'x'"$HAS_EQ" = 'x' ]
    then
        :
    else
        NAME=`echo $LINE | sed -e 's/\([A-Z]*\) =.*/\1/g'`
        VALUE=`echo $LINE | sed -e 's/\(.*\) = \(.*\),/\2/g'`
        echo "name:$NAME value:$VALUE"
    fi

    find_replace $VALUE $NAME
done < $FILE

