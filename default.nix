{ pkgsPath ? <nixpkgs> }:

with rec { 
    haxe4nix = 
        (import pkgsPath {}).fetchFromGitHub {
            owner = "run4w4y";
            repo = "haxe4nix";
            rev = "657b8eb6bd6c783d25956c47957007a5cbc7d38b";
            sha256 = "14mgqrjknihw3qygmkn8n0kyh58qpgarfdjx6silk4ywz0jm6x7a";
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
            neko
        ];
    shellHook = 
        ''
            # fix terminal behavior when running shell with --pure
            export TERM=xterm-256color
        '';
}