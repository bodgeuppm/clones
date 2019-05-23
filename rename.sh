#!/bin/bash

VERBOSE="true"

function test {
        if [ ! -z "$TEST" ]; then echo $1; fi
}

function real {
        if [ -z "$TEST" ]; then echo $1; fi
}

if [ "$1" = "test" ]; then
        TEST="true"
else
        TEST=""
fi

find . -type d | grep -v "/.*/" | grep "/" | cut -b 3- | while read series; do
        cd "$series"
        if [ -f .ended ]; then
                test "$series has ended."
        elif [ -f .url ]; then
                real "Updating titles of $series..."
                test "Checking $series..."

                wget -i .url -O - -o /dev/null | grep "^[[:digit:]]" | cut -d , -f 2,3,6 | sed 's/\"//g' | sed 's/\//-/g' > .eps
                errors=`ls | grep -v "^[[:digit:]][[:digit:]]x[[:digit:]][[:digit:]]\.[[:alnum:]][[:alnum:]][[:alnum:]]$" | grep -v "^[[:digit:]][[:digit:]]x[[:digit:]][[:digit:]] - [[:alnum:][:punct:][:space:]]\+\.[[:alnum:]][[:alnum:]][[:alnum:]]$"`

                if [ ! -z "$errors" ]; then
                        echo "Error! Offending files:"
                        echo "$errors"
                else
                        counter=0
                        failcounter=0 
                        echo $counter > .count
                        echo $failcounter > .failcount
                        ls | grep -v "-" | grep "^[[:digit:]][[:digit:]]x[[:digit:]][[:digit:]]\.[[:alnum:]][[:alnum:]][[:alnum:]]$" | while read file; do
                                season=`echo $file | cut -b 1-2 | sed 's/^0//'`
                                episode=`echo $file | cut -b 4-5 | sed 's/^0//'`
                                extension=`echo $file | cut -b 7-9`
                                name=`echo ^$season,$episode, | grep -f - .eps | cut -d , -f 3`
                                if [ ! -z "$name" ]; then
                                        newfile="`printf %02d $season`x`printf %02d $episode` - $name.$extension"
                                        if [ $VERBOSE = "true" ]; then
                                                test "$file would become $newfile."
                                                real "Updating title of $file to $newfile."

                                        fi
                                        counter=$[counter+1]
                                        echo $counter > .count
                                        if [ -z "$TEST" ]; then
                                                echo mv "$file" "$newfile"
                                        fi
                                else
                                        echo "$file has no title!"
                                        failcounter=$[failcounter+1]
                                        echo $failcounter > .failcount
                                fi
                        done 
                        counter=`cat .count`  
                        failcounter=`cat .failcount`
                        test "$counter files would get new titles, $failcounter would fail."
                        real "Updated $counter titles, $failcounter unsuccessful."

                        rm .count
                        rm .failcount
                        rm .eps

                        real "----------"
                        real

                fi
        else 
                test "$series has no URL."
        fi
        test
        cd ..
done
