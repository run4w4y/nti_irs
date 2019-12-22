package hashset;

import polygonal.ds.ListSet;


abstract HashSet<T>(ListSet<String>) {
    public function new():Void {
        this = new ListSet<String>();
    }

    public function add(value:T):Bool {
        return this.set(Std.string(value));
    }

    public function has(value:T):Bool {
        return this.has(Std.string(value));
    }
}