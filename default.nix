let 
    pkgs = import ./pkgs.nix {}; 
    haxePackages = import ./haxeDeps.nix;
in

pkgs.stdenv.mkDerivation {
    name = "nti_irs";
    src = ./.;

    buildInputs = with pkgs; [
        haxe
    ];

    configurePhase = ''
        export HOME="$(pwd)"
        echo "$(pwd)" > .haxelib
    '';

    installPhase = ''
        mkdir -p lib
        haxelib setup ./lib --quiet
        haxelib dev polygonal-ds ${haxePackages.polygonal-ds} --quiet
        rm -rf build.js
        haxe build.hxml
        mkdir -p $out
        mv build.js $out 
    '';
}