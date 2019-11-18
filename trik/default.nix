with rec {
    bs-platform = 
        pkgs.fetchFromGitHub {
            owner = "turboMaCk";
            repo = "bs-platform.nix";
            rev = "49fdbb03e0598500cf22ec497d037efb22809969";
            sha256 = "0l1lp0rg0v9ynhb5s4vxzxsv1w0wixc5g5xw2pqdcjqx6acbzns8";
        };
    pkgs = 
        import <nixpkgs> {};
};
pkgs.mkShell {
    buildInputs = [
        bs-platform
    ];
    shellHook = ''
        # fix terminal behavior when running shell with --pure
        export TERM=xterm-256color
    '';
}