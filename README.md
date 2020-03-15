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
