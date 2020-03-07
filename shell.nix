{ pkgs ? import ./pkgs.nix {} }:

let 
    haxePackages = import ./haxeDeps.nix; 
in

with pkgs;
mkShell {
    buildInputs = 
        [ 
            git 
            haxe
            neko
        ];
    shellHook = 
        ''
            # fix terminal behavior when running shell with --pure
            export TERM=xterm-256color
            # patch haxe up
            export HOME="$(pwd)"
            echo "$(pwd)" > .haxelib
            # set up haxelib and deps
            haxelib --quiet setup ./lib 
            haxelib --quiet dev polygonal-ds ${haxePackages.polygonal-ds}
            haxelib --quiet dev utest ${haxePackages.utest}
        '';
}