#!/bin/sh

upload_file () {
    echo "Uploading $1 to $2"
    scp -q -o StrictHostKeyChecking=no "$1" "root@$2:~/trik/scripts/"
    echo "Done"
}

for file in result/*.js; do
    upload_file "$file" "$1"
done