with import ./pkgs.nix {}; {
    polygonal-ds = stdenv.mkDerivation rec {
        name = "polygonal-ds-${version}";
        version = "2.1.1";
        src = pkgs.fetchgit {
            url = "https://github.com/polygonal/ds.git";
            rev = "26a69dfaac9a602607f84b8e59995e716af4bf12";
            sha256 = "14mwk3yir876bd41mgcj70v4gibvz1fv28208dcb1w2hxxz1qpm5";
        };
        phases = "installPhase";
        installPhase = "ln -s $src $out";
    };
    utest = stdenv.mkDerivation rec {
        name = "utest-${version}";
        version = "1.10.1";
        src = builtins.fetchTarball {
            url = "https://github.com/haxe-utest/utest/archive/${version}.tar.gz";
            sha256 = "1hqw02b5q7ayjfyyqskb2wwwwd2cx30qpgsbnnp5frfgjlz6s5pc";
        };
        phases = "installPhase";
        installPhase = "ln -s $src $out";
    };
}