### Entering the shell
```bash
nix-shell --pure
```

### Installing dependencies
```bash
haxelib install polygonal-ds 2.0.1
haxelib install json2object
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