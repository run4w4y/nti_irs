with import <nixpkgs> {};

let
    my-python-packages =
        python-packages:
        with python-packages; [
            scipy
            numpy
            matplotlib
        ];
in
    mkShell {
        buildInputs = [
            (python3.withPackages my-python-packages)
        ]; 
        shellHook = ''
            # fix terminal behavior when running shell with --pure
            export TERM=xterm-256color 
        '';
    }