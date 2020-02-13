package science.geometry;

import science.geometry.Point;


@:forward
abstract Vector<T:Float>(Point<T>) from Point<T> to Point<T> {
    public function new(x:T, y:T):Void {
        this = new Point<T>(x, y);
    }

    @:op(A + B)
    public function add<T1:Float>(p:Point<T1>):Vector<Float> {
        return new Vector<Float>(this.x + p.x, this.y + p.y);
    }

    @:op(-A)
    public function neg():Vector<T> {
        return new Vector<T>(-this.x, -this.y);
    }

    @:op(A - B)
    public function sub<T1:Float>(p:Point<T1>):Vector<Float> {
        return new Vector<Float>(this.x - p.x, this.y - p.y);
    }

    @:op(A * B)
    public function mul<T1:Float>(k:T1):Vector<Float> {
        return new Vector<Float>(this.x * k, this.y * k);
    }

    @:op(A / B)
    public function div<T1:Float>(k:T1):Vector<Float> {
        return new Vector<Float>(this.x / k, this.y / k);
    }

    @:op(A % B)
    public function scalar_product<T:Float>(point:Point<T>):Float {
        return this.x * point.x + this.y * point.y;
    }

    @:op(A * B)
    public function vector_product<T:Float>(point:Point<T>):Float {
        return this.x * point.y - this.y * point.x;
    }

    public function length():Float {
        return scalar_product(this);
    }
}