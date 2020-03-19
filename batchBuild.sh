#!/bin/sh

exitCode=0

patchFile() {
    sed 's/Type.typeof/Type.typeOf/g' "$1" > "$1.tmp"
    rm "$1"
    mv "$1.tmp" "$1"
}

buildHaxe() {
    echo "Building $1""_$3.js with main $5"
    local base64Input=$(echo "$2" | base64)
    haxe \
        --macro "addGlobalMetadata('', '@:build(Build.buildReal())')" \
        --macro "addGlobalMetadata('', '@:build(Build.build())')" \
        -cp src \
        -D js-es=3 \
        -D "$1=$2" \
        -js "builds/out/$4/$1""_$3.js" \
        -main $5 \
        -lib polygonal-ds
    if (( $? != 0 )); then 
        exit $?
    fi
    patchFile "builds/out/$4/$1""_$3.js"
}

mkdir -p "builds/out/$1"
buildInputPath="builds/in/$1.in"

curName=
curTest=''
curMain=
testCount=0

while IFS= read line; do
    case "$line" in
        *:*)
            ARR=(${line//:/ })
            curName=${ARR[0]}
            curMain=${ARR[1]}
            testCount=0
            ;;
        ---*)
            testCount=$(( $testCount + 1 ))
            buildHaxe "$curName" "$curTest" $testCount "$1" $curMain
            curTest=
            ;;
        ===*)
            testCount=$(( $testCount + 1 ))
            buildHaxe "$curName" "$curTest" $testCount "$1" $curMain
            curName=
            curTest=
            curMain=
            testCount=0
            ;;
        *)
            if [ -z "$curTest" ]; then
                curTest="$line"
            else
                curTest=$(printf "$curTest\n$line")
            fi
            ;;
    esac
done < "$buildInputPath"

sliceFrom=
for ((i=0; i<$#; i++)); do
    if [[ ${!i} == "--upload" ]]; then
        sliceFrom=$(( $i + 1 ))
    fi
done

if [ -z "$sliceFrom" ]; then
    exit 0
else 
    ips=${@:$sliceFrom}
    ./upload.sh builds/out/$1/*.js -- "$ips"
fi