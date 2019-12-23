### Entering the shell
```bash
nix-shell --pure
```

### Installing dependencies
Build dependencies:
```bash
haxelib install build.hxml
```
Tests dependencies:
```bash
haxelib install test.hxml
```

Make sure you have haxelib configured
```bash
haxelib setup ./lib
```

### Building the code
Compile the code to js
```bash
haxe build.hxml
```
or run it locally for testing
```bash
haxe test.hxml
```

### Running linting server
```bash
haxe --wait 6000 &
```

### Tips
You might want to use `xclip` CLI tool, to copy and paste code in the TRIK Studio faster. Example usage:
```bash
xclip -sel cli < builds/main.js
```
This command copies the contents of `builds/main.js` to your clipboard.

### Documentation
Documentation is currently being written. You can check out what's got documented so far in [Wiki](https://github.com/run4w4y/nti_irs/wiki)
