package trik.geometry;

import trik.geometry.Point;

@:forward
abstract Vector(Point) {
    public function new(x: Float, y:Float) {
        this = new Point(x, y);
    }

    @:op(A % B)
    public function scalar_product(point:Point):Float {
        return this.x * point.x + this.y * point.y;
    }

    @:op(A ^ B)
    public function vector_product(point:Point) {
        return this.x * point.y - this.y * point.x;
    }

    public function length():Float {
        return scalar_product(this);
    }
}