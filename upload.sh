#!/bin/sh

sliceTo=$(( $# - 1 ))
sliceFrom=$(( $# ))
for ((i=0; i<$#; i++)); do
    if [[ ${!i} == "--" ]]; then
        sliceTo=$(( $i - 1 ))
        sliceFrom=$(( $i + 1 ))
    fi
done

files=${@:1:$sliceTo}
ips=${@:$sliceFrom}

shift
for ip in ${ips[@]}; do
    for file in ${files[@]}; do
        echo "Uploading $file to $ip"
        scp -q -o StrictHostKeyChecking=no "$file" "root@$ip:~/trik/scripts/"
        echo "Done"
    done
done