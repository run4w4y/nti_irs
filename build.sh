#!/bin/sh

patchFile() {
    local newName=$(basename "$1" .js)Patched.js
    sed 's/Type.typeof/Type.typeOf/g' "$1" > "builds/out/$newName"
    rm -rf "$1"
}

rm builds/out/*.js
exitSum=0
haxe build.hxml
exitSum=$(( $exitSum + $? ))
haxe gyroCalibration.hxml
exitSum=$(( $exitSum + $? ))

patchFile "builds/out/build.js"
patchFile "builds/out/calibration.js"

exit $exitSum