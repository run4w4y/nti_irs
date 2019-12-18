{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
    buildInputs = with pkgs; [ git haxe ];
    shellHook = ''
        # fix terminal behavior when running shell with --pure
        export TERM=xterm-256color
        # run intellisense server
        haxe --wait 6000 &
    '';
}