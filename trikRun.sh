#!/bin/sh

byteLength() {
    local len oldLang=$LANG oldLC_All=$LC_ALL
    LANG=C LC_ALL=C
    len=${#1}
    LANG=$oLang LC_ALL=$oLcAll
    echo $len
}

cmdWrap() {
    local cmd="$1"
    if [ "$#" == 2 ]; then
        local size="$2"
    else
        local size=$(byteLength $cmd)
    fi
    echo "$size:$cmd"
}

if [ "$#" == 0 ]; then 
    echo "Filepath is required"
    exit -1
fi

filepath="$1"

if [ "$#" == 2 ]; then 
    address="$2"
else
    address='192.168.77.1'
fi

filename=$(basename "$filepath")
fileCmd="file:$filename:"

cmdLen=$(( $(byteLength "$fileCmd") + $(stat --printf="%s" "$filepath") ))
fileCmd=$(cmdWrap $fileCmd $cmdLen)

file=$(cat "$filepath")
runCmd=$(cmdWrap "run:$filename")
echo "$fileCmd$file$runCmd" - | nc $address 8888

KEEPALIVE_PERIOD=3
last_keepalive=$SECONDS
while :; do
    data=""
    while :; do
        r=$(nc -vv -l 8888 -I 1 )
        if [ $r != ":" ]; then
            data="$data$r"

            if (( $SECONDS - $last_keepalive >= $KEEPALIVE_PERIOD )); then
                last_keepalive=$SECONDS
                echo "9:keepalive" - | nc $address 8888
            fi
        else
            break
        fi
    done

    echo $data
    case "$data" in
        "*:keepalive*")
            last_keepalive=$SECONDS
            echo "9:keepalive" - | nc $address 8888
            ;;
        "*:print:*")
            IFS=":"
            read -ra ARR <<< "$data"
            echo "${ARR[-1]}"
            ;;
        "*:error:*")
            IFS=":"
            read -ra ARR <<< "$data"
            echo "Received an error: ${ARR[-1]}"
            exit -1
            ;;
        *)
            echo "Received an unknown command"
            ;;
    esac
    sleep 0
done