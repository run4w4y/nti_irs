{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
    buildInputs = with pkgs; [ haxe ];
    shellHook = ''
        # fix terminal behavior when running shell with --pure
        export TERM=xterm-256color
    '';
}