package src.geometry;

import src.trik.exceptions.SamePointException;
import src.geometry.PointLike;
import src.geometry.Point;
import Math.*;


class Line {
    public var a:Float;
    public var b:Float;
    public var c:Float;
    public var point1:Point;
    public var point2:Point;

    @:generic
    public function new<T:PointLike>(pointLike1:T, pointLike2:T) {
        if (abs(pointLike1.x - pointLike2.x) <= 1e-6 && abs(pointLike1.y - pointLike2.y) <= 1e-6) 
            throw new SamePointException('cant define a line with two same points');
        
        this.point1 = new Point(pointLike1.x, pointLike1.y);
        this.point2 = new Point(pointLike2.x, pointLike2.y);

        a = pointLike1.y - pointLike2.y;
        b = pointLike2.x - pointLike1.x;
        c = -a * pointLike1.x - b * pointLike1.y;
    }

    public function moveX(value:Float):Line {
        var delta = new Point(value, 0);
        return new Line(
            point1.add(delta),
            point2.add(delta)
        );
    }

    public function moveY(value:Float):Line {
        var delta = new Point(0, value);
        return new Line(
            point1.add(delta),
            point2.add(delta)
        );
    }

    public function moveXY(valueX:Float, valueY:Float):Line {
        var delta = new Point(valueX, valueY);
        return new Line(
            point1.add(delta),
            point2.add(delta)
        );
    }

    public function getX(y:Float):Float {
        return -(c + b*y)/a;
    }

    public function getY(x:Float):Float {
        return -(a*x + c)/b;
    }

    public function getPointX(x:Float):Point {
        return new Point(x, getY(x));
    }

    public function getPointY(y:Float):Point {
        return new Point(getX(y), y);
    }

    public function toString():String {
        return 'Line($a, $b, $c)';
    }
}