package trik.geometry;

import trik.geometry.PointInternal;
import Math.*;
import trik.exceptions.SamePointException;


@:forward
abstract Point(PointInternal) {
    public function new(?x:Float=0, ?y:Float=0):Void {
        this = new PointInternal(x, y);
    }

    @:op(A + B)
    public function sum(point:Point):Point {
        return new Point(this.x + point.x, this.y + point.y);
    }

    @:op(-A)
    public function neg():Point {
        return new Point(-this.x, -this.y);
    }

    @:op(A - B)
    public function sub(point: Point):Point {
        return new Point(this.x - point.x, this.y - point.y);
    }

    @:op(A * B)
    public function mul(k:Float):Point {
        return new Point(this.x * k, this.y * k);
    }

    @:op(A / B)
    public function div(k:Float):Point {
        return new Point(this.x / k, this.y / k);
    }

    public function toString():String {
        return 'Point(${this.x}, ${this.y})';
    }
}