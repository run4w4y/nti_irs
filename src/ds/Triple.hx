package ds;

import ds.Pair;


class Triple<T1, T2, T3> extends Pair<T1, T2> {
    public var third:T3;

    public function new(f:T1, s:T2, t:T3):Void {
        super(f, s);
        third = t;
    }

    override public function toString():String {
        return '{$first, $second, $third}';
    }
}