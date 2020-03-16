#!/bin/sh

patch_file() {
    local newName=$(basename "$1" .js)Patched.js
    sed 's/Type.typeof/Type.typeOf/g' "$1" > "$newName"
    rm -rf "$1"
}

haxe build.hxml
haxe gyroCalibration.hxml
for buildResult in *.js; do 
    patch_file "$buildResult"
done