with import <nixpkgs> {};

let
    pythonPackages = 
        pyPkgs:
        with pyPkgs; [
            scipy
            numpy
            matplotlib
            ipython
            pillow
            pygobject3
        ];
in
    mkShell {
        buildInputs = [
            (python3.withPackages pythonPackages)
            gobjectIntrospection gtk3
        ];
        shellHook = ''
            export TERM=xterm-256color
        '';
    }