package trik.tools;

import trik.exceptions.SamePointException;
import trik.geometry.Line;
import trik.geometry.Point;
import Math.*;


class GeometryTools {
    public static function distToLine(point:Point, line:Line) {
        var d:Float = line.point1.distTo(line.point2);
        if (d == 0) 
            throw new SamePointException("cant define a line with two same points");
        
        var s:Float = (point.sub(line.point1)).vector_product(point.sub(line.point2));
        return abs(s)/d;
    }

    public static function det(a:Float, b:Float, c:Float, d:Float):Float {
        return a * d - b * c;
    }

    public static function getIntersectionPoint(line1:Line, line2:Line):Point {
        var zn:Float = det(line1.a, line1.b, line2.a, line2.b);

        return new Point();
    }
}