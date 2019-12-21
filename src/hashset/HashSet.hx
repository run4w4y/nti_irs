package hashset;

import polygonal.ds.ListSet;


typedef Hashable = {
    function toString():String;
}

abstract HashSet<T:Hashable>(ListSet<String>) {
    public function new():Void {
        this = new ListSet<String>();
    }

    public function add(value:T):Bool {
        return this.set(value.toString());
    }

    public function has(value:T):Bool {
        return this.has(value.toString());
    }
}