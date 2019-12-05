package trik.geometry;

import trik.exceptions.SamePointException;
import trik.geometry.Point;


class Line {
    public var a:Float;
    public var b:Float;
    public var c:Float;
    public var point1:Point;
    public var point2:Point;

    public function new(point1:Point, point2:Point) {
        if (point1.distTo(point2) == 0) 
            throw new SamePointException('cant define a line with two same points');
        
        this.point1 = point1;
        this.point2 = point2;

        a = point1.y - point2.y;
        b = point2.x - point1.x;
        c = -a * point1.x - b * point1.y;
    }

    public function getX(y:Float):Float {
        return -(c + b*y)/a;
    }

    public function getY(x:Float):Float {
        return -(a*x + c)/b;
    }

    public function toString():String {
        return 'Line($point1, $point2)';
    }
}