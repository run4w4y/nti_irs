package hashmap;


@:forward
abstract HashMap<K, V>(Map<String, V>) {
    public function new():Void {
        this = new Map<String, V>();
    }

    @:arrayAccess
    public inline function get(key:K):V {
        return this.get(Std.string(key));
    }

    @:arrayAccess
    public inline function set(key:K, val:V):V {
        this.set(Std.string(key), val);
        return val;
    }
}