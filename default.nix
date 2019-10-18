{ pkgs ? import <nixpkgs> {} }:

let
    easy-ps = import (pkgs.fetchFromGitHub {
        owner = "justinwoo";
        repo = "easy-purescript-nix";
        rev = "7d072cef5ad9dc33a9a9f1b7fcf8ff083ff484b3";
        sha256 = "0974wrnp8rnmj1wzaxwlmk5mf1vxdbrvjc1h8jgm9j5686qn0mna";
    }) {
        inherit pkgs;
    };
in 
    pkgs.mkShell {
        buildInputs = with easy-ps; [
            purs
            psc-package-simple
            purp
            spago
            pkgs.which
        ];

        shellHook = ''
            # fix terminal behavior when running shell with --pure
            export TERM=xterm-256color
        '';
    }
