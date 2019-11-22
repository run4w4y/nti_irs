package trik.hashmap;

import trik.hashmap.Hashable;


@:forward
abstract HashMap<K:Hashable, V>(Map<String, V>) {
    public function new () {
        this = new Map<String, V>();
    }

    @:arrayAccess
    public inline function get (key:K):V {
        return this.get(key.toString());
    }

    @:arrayAccess
    public inline function set (key:K, val:V):V {
        this.set(key.toString(), val);
        return val;
    }
}