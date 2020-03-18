#!/bin/sh

patch_file() {
    local newName=$(basename "$1" .js)Patched.js
    sed 's/Type.typeof/Type.typeOf/g' "$1" > "$newName"
    rm -rf "$1"
}

rm *.js
exitSum=0
haxe build.hxml
exitSum=$(( $exitSum + $? ))
haxe gyroCalibration.hxml
exitSum=$(( $exitSum + $? ))
for buildResult in *.js; do 
    patch_file "$buildResult"
done
exit $exitSum