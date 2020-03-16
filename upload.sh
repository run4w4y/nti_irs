#!/bin/sh

upload_file () {
    echo "Uploading $1 to $2"
    scp -q -o StrictHostKeyChecking=no "$1" "root@$2:~/trik/scripts/"
    echo "Done"
}

if [ "$#" == 1 ]; then
    for file in result/*.js; do
        upload_file "$file" "$1"
    done
else
    file="$1"
    shift
    for i; do
        upload_file "$file" "$i"
    done
fi