#!/bin/bash
if [ ! -f $PWD/.env ]; then
    touch $PWD/.env;
    while read LINE; do
        if [[ $LINE == \#* ]]
        then
            if [[ $LINE != \#!* ]]; then
                echo $LINE;
            fi
            echo $LINE >> $PWD/.env;
        elif [ -z $LINE ]; then
            echo $LINE >> $PWD/.env;
        else
            IFS== read NAME DEFAULT <<< $LINE;

            read -p "$NAME [$DEFAULT]" VALUE < /dev/tty;
            if [ -z $VALUE ]; then
                VALUE=$DEFAULT;
            fi
            echo $NAME=$VALUE >> $PWD/.env;
        fi
    done < $PWD/.env.example
else
    echo "The .env file is already created.";
fi
