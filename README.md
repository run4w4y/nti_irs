### Entering the shell
```bash
nix-shell --pure
```

### Installing dependencies
```bash
haxelib install polygonal-ds 2.0.1
```

Make sure you have haxelib configured
```bash
haxelib setup ./lib
```

### Building the code
```bash
haxe build.hxml
```

### Run linting server
```bash
haxe --wait 6000 &
```
