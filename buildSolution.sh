patchFile() {
    sed 's/Type.typeof/Type.typeOf/g' "$1" > "$1.tmp"
    rm "$1"
    mv "$1.tmp" "$1"
}

haxe \
    --macro "addGlobalMetadata('', '@:build(Build.build())')" \
    -cp src \
    -D js-es=3 \
    -js "builds/out/$2" \
    -main $1 \
    -lib polygonal-ds 
patchFile "builds/out/$2"