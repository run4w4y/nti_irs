with import <nixpkgs> {};

let
    my-python-packages =
        python-packages:
        with python-packages; [
            matplotlib pygobject3 ipython
            pillow
        ];
in
    mkShell {
        buildInputs = [
            (python3.withPackages my-python-packages)
            gobjectIntrospection gtk3
        ]; 
        shellHook = ''
            # fix terminal behavior when running shell with --pure
            export TERM=xterm-256color 
        '';
    }