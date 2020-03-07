{ pkgs ? import ./pkgs.nix {} }:

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
        '';
}