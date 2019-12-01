package trik.geometry;

import Math.*;
import trik.exceptions.SamePointException;


class Point {
    public var x:Float;
    public var y:Float;

    public function new( ?x:Float = 0, ?y:Float = 0 ):Void {
        this.x = x;
        this.y = y;
    }

    public function sum(point:Point):Point {
        return new Point(this.x + point.x, this.y + point.y);
    }

    public function sub(point:Point):Point {
        return new Point(this.x - point.x, this.y - point.y);
    }

    public function neg():Point {
        return new Point(-this.x, -this.y);
    }

    public function mul(koef:Float):Point {
        return new Point(this.x * koef, this.y * koef);
    }

    public function div(koef:Float):Point {
        return new Point(this.x / koef, this.y / koef);
    }
    
    public function scalar_product(point:Point):Float {
        return this.x * point.x + this.y * point.y;
    }

    public function vector_product(point:Point):Float {
        return this.x * point.y - this.y * point.x;
    }

    public function length():Float {
        return this.scalar_product(this);
    }

    public function distTo(point:Point):Float {
        return this.sub(point).length();
    }

    public function distToLine(a:Point, b:Point) {
        var d:Float = a.distTo(b);
        if (d == 0) 
            throw new SamePointException("cant define a line with two same points");
        var s:Float = (this.sub(a)).vector_product(this.sub(b));
        return abs(s)/d;
    }
}