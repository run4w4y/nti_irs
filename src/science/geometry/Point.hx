package science.geometry;

import ds.Pair;


abstract Point<T:Float>(Pair<T, T>) from Pair<T, T> to Pair<T, T> {
    public var x(get, set):T;
    public var y(get, set):T;

    private function get_x():T {
        return this.first;
    }

    private function set_x(value:T):T {
        return this.first = value;
    }

    private function get_y():T {
        return this.second;
    }

    private function set_y(value:T):T {
        return this.second = value;
    }

    public function new(x:T, y:T):Void {
        this = new Pair<T, T>(x, y);
    }

    public function round():Point<Int> {
        return new Point<Int>(Math.round(x), Math.round(y));
    }

    @:op(A + B)
    public function add<T1:Float>(p:Point<T1>):Point<Float> {
        return new Point<Float>(x + p.x, y + p.y);
    }

    @:op(-A)
    public function neg():Point<T> {
        return new Point<T>(-x, -y);
    }

    @:op(A - B)
    public function sub<T1:Float>(p:Point<T1>):Point<Float> {
        return new Point<Float>(x - p.x, y - p.y);
    }

    @:op(A * B)
    public function mul<T1:Float>(k:T1):Point<Float> {
        return new Point<Float>(x * k, y * k);
    }

    @:op(A / B)
    public function div<T1:Float>(k:T1):Point<Float> {
        return new Point<Float>(x / k, y / k);
    }

    public function toString():String {
        return 'Point(${this.first}, ${this.second})';
    }
}