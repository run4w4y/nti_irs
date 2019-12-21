{ pkgsPath ? <nixpkgs> }:

with rec { 
    haxe4nix = 
        (import pkgsPath {}).fetchFromGitHub {
            owner = "run4w4y";
            repo = "haxe4nix";
            rev = "861780f940c8c0eaed8ffd03b42c707dfeba1a4b";
            sha256 = "065ajmk1bz7il1vv239qg453n6ig7g4jq4611bc1s012grbchp2h";
        };
    pkgsOverlay = 
        import "${haxe4nix}/nixpkgs-overlay";
    pkgs = 
        import pkgsPath { overlays = [ pkgsOverlay ]; };
};
with pkgs;

mkShell {
    buildInputs = 
        [ 
            git 
            haxe
        ];
    shellHook = 
        ''
            alias haxe=${haxe}/haxe
            alias haxelib=${haxe}/haxelib
            # fix terminal behavior when running shell with --pure
            export TERM=xterm-256color
            # run intellisense server
            haxe --wait 6000 &
        '';
}