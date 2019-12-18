{ pkgsPath ? <nixpkgs> }:

let 
    haxe-repo = (import pkgsPath {}).fetchFromGitHub {
        owner = "vizanto";
        repo = "nixlixhx";
        rev = "205548120145c43fb2d7dbe1aae41e8de21ecf91";
        sha256 = "1p2ycy2ljsim5fy20zkd2ghrc1arr7jhdpgkp6h32zvqzkni66gf";
    };
    pkgs = import pkgsPath { overlays = [(import "${haxe-repo}/nixpkgs-overlay")]; };
in
    pkgs.mkShell {
        buildInputs = with pkgs; [ 
            coreutils-full
            gnumake
            clang
            git
            lix
            hashlink
            neko
            haxe4
        ];
        shellHook = ''
            # fix terminal behavior when running shell with --pure
            export TERM=xterm-256color
            # run intellisense server
            haxe --wait 6000 &
        '';
    }