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
filename=$(basename "$filepath")

if [ "$#" == 2 ]; then 
    address="$2"
else
    address='192.168.77.1'
fi

./upload.sh "$filepath" $address

exec 3<> "/dev/tcp/$address/8888"

trap ctrl_c INT

ctrl_c() {
    echo \nStopping...
    echo -n "4:stop" >&3
    exec 3<&-
    exit 0
}

runCmd=$(cmdWrap "run:$filename")
echo -n "$runCmd" >&3

KEEPALIVE_PERIOD=3
last_keepalive=$SECONDS

while :; do
    IFS=
    data=""
    while :; do
        read -n 1 b 0<&3
        if [[ "$b" != ":" ]]; then
            data="$data$b"

            if (( $SECONDS - $last_keepalive >= $KEEPALIVE_PERIOD )); then
                last_keepalive=$SECONDS
                echo -n "9:keepalive" >&3
            fi
        else
            break
        fi
    done

    read -n $data cmdRaw <&3
    IFS=":"
    read -ra ARR <<< "$cmdRaw"
    cmd="${ARR[0]}"
    if (( "${#ARR[@]}" == 1 )); then
        arg=""
    else
        arg="${ARR[-1]}"
    fi

    res=""
    case "$cmd" in
        keepalive)
            last_keepalive=$SECONDS
            echo -n "9:keepalive" >&3
            ;;
        print)
            echo "$arg" >&2
            ;;
        error)
            echo "Received an error: $arg" >&2
            exit -1
            ;;
        *)
            echo "Received an unknown command" >&2
            ;;
    esac
    sleep 0
done