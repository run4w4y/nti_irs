package src.trik.geometry;

import src.trik.geometry.PointLike;
import Math.*;
import src.trik.exceptions.SamePointException;


class Point {
    public var x:Float;
    public var y:Float;

    public function new(?x:Float=0, ?y:Float=0):Void {
        this.x = x;
        this.y = y;
    }

    @:generic
    public function add<T:PointLike>(pointLike:T):Point {
        return new Point(this.x + pointLike.x, this.y + pointLike.y);
    }

    public function neg():Point {
        return new Point(-this.x, -this.y);
    }

    @:generic
    public function sub<T:PointLike>(pointLike:T):Point {
        return new Point(this.x - pointLike.x, this.y - pointLike.y);
    }

    public function mul(k:Float):Point {
        return new Point(this.x * k, this.y * k);
    }

    public function div(k:Float):Point {
        return new Point(this.x / k, this.y / k);
    }

    public function toString():String {
        return 'Point(${this.x}, ${this.y})';
    }
}