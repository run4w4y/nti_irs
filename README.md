[![Actions Status](https://github.com/run4w4y/nti_irs/workflows/CI/badge.svg)](https://github.com/run4w4y/nti_irs/actions)

# Building the code
## With nix
```bash
nix-build
```
the build output is `/result/build.js`

## Without nix
```bash
./build.sh
```

## Build day solutions
To get your day solutions built do:
```bash
./batchBuild.sh dayN
```
This will result in files like `builds/out/dayN/real_1_1.js` and so on.
To have your build output uploaded as well, add `--upload ip1 ip2 ...` in the end of the command above.

Note that `builds/in/dayN.in` must be defined for that. To pass the inputs from `.in` file to your haxe code use `@:inputFrom` metadata. Example:
```haxe
class Model extends RobotModel {
    @:inputFrom("real_1")
    static function getInput():String return "";
    
    public function solution():Void {
        // your solution goes here
    }
}
```

# Uploading builds
## Upload and run
```bash
./trikRun.sh [path] [ip]
```
Script.print calls are echoed to stdout while script runs. Ctrl+C stops execution on the TRIK brick.
You can also omit the ip if it's meant to be 192.168.77.1

## Upload
```bash
./upload.sh [path1 path2 ...] -- [ip1 ip2 ...]
```
`--` is omittable if there's only one ip

# Development
## Entering nix-shell
```bash
nix-shell --pure
```

## Run unit tests
### With nix
```bash
nix test.nix
```
### Without nix/within nix-shell
```bash
haxe test.hxml
```

## Tips
You might want to use `xclip` CLI tool, to copy and paste code in the TRIK Studio faster. Example usage:
```bash
xclip -sel cli < result/patched.js
```
This command copies the contents of `result/build.js` to your clipboard.

# Working without nix
## Configuring haxelib
```bash
haxelib setup ./lib
```

## Installing dependencies
Build dependencies:
```bash
haxelib install build.hxml
```
Tests dependencies:
```bash
haxelib install test.hxml
```

# Second stage solutions
You can find our team solutions for the second stage online tasks in the `archive` folder. 

# Documentation
Documentation is currently being written. You can check out what's got documented so far in [Wiki](https://github.com/run4w4y/nti_irs/wiki)
