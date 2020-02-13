package science.geometry;

import science.geometry.exceptions.SamePointException;
import science.geometry.Point;
import Math.*;


class Line {
    public var a:Float;
    public var b:Float;
    public var c:Float;
    public var point1:Point<Float>;
    public var point2:Point<Float>;

    public function new<T:Float>(point1:Point<T>, point2:Point<T>) {
        if (abs(point1.x - point2.x) <= 1e-6 && abs(point1.y - point2.y) <= 1e-6) 
            throw new SamePointException('cant define a line with two same points');
        
        this.point1 = new Point<Float>(point1.x, point1.y);
        this.point2 = new Point<Float>(point2.x, point2.y);

        a = point1.y - point2.y;
        b = point2.x - point1.x;
        c = -a * point1.x - b * point1.y;
    }

    public function moveX(value:Float):Line {
        var delta = new Point<Float>(value, 0);
        return new Line(
            point1 + delta,
            point2 + delta
        );
    }

    public function moveY(value:Float):Line {
        var delta = new Point<Float>(0, value);
        return new Line(
            point1 + delta,
            point2 + delta
        );
    }

    public function moveXY(valueX:Float, valueY:Float):Line {
        var delta = new Point<Float>(valueX, valueY);
        return new Line(
            point1 + delta,
            point2 + delta
        );
    }

    public function getX(y:Float):Float {
        return -(c + b*y)/a;
    }

    public function getY(x:Float):Float {
        return -(a*x + c)/b;
    }

    public function getPointX(x:Float):Point<Float> {
        return new Point<Float>(x, getY(x));
    }

    public function getPointY(y:Float):Point<Float> {
        return new Point<Float>(getX(y), y);
    }

    public function toString():String {
        return 'Line($a, $b, $c)';
    }
}