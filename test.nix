let
    haxePackages = import ./haxeDeps.nix;
    pkgs = import ./pkgs.nix {};
in
pkgs.stdenv.mkDerivation {
    name = "nti_irs_tests";
    src = ./.;

    buildInputs = with pkgs; [
        haxe
        neko
    ];

    configurePhase = ''
        export HOME="$(pwd)"
        echo "$(pwd)" > .haxelib
    '';

    installPhase = ''
        mkdir -p lib
        haxelib setup ./lib --quiet
        haxelib dev polygonal-ds ${haxePackages.polygonal-ds} --quiet
        haxelib dev utest ${haxePackages.utest} --quiet
        haxe test.hxml
        rm -rf build.js
        haxe build.hxml
        mkdir -p $out
        mv build.js $out
    '';
}