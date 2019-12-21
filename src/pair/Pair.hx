package src.pair;

class Pair<T1, T2> {
    public var first:T1;
    public var second:T2;

    public function new(first:T1, second:T2):Void {
        this.first = first;
        this.second = second;
    }

    public function toString():String {
        return '{$first, $second}';
    }
}