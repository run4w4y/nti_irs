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

### Run linting server
```bash
haxe --wait 6000 &
```
