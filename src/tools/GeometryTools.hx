package tools;

import science.geometry.Line;
import science.geometry.Point;
import science.geometry.Vector;
import Math.*;


class GeometryTools {
    public static var epsilon = 1e-6;

    public static function distToLine<T:Float, P:Point<T>>(p:P, line:Line) {
        var d:Float = distTo(line.point1, line.point2);
        var vector:Vector<T> = p;
        var s:Float = (vector - line.point1) * (vector - line.point2);
        return abs(s)/d;
    }

    static function det(a:Float, b:Float, c:Float, d:Float):Float {
        return a * d - b * c;
    }

    public static function paralell(line1:Line, line2:Line) {
        return abs(det(line1.a, line1.b, line2.a, line2.b)) <= epsilon;
    }

    public static function equivalent(line1:Line, line2:Line):Bool {
        return abs(det(line1.a, line1.b, line2.a, line2.b)) < epsilon
           && abs(det(line1.a, line1.c, line2.a, line2.c)) < epsilon
           && abs(det(line1.b, line1.c, line2.b, line2.c)) < epsilon;
    }

    public static function getIntersectionPoint(line1:Line, line2:Line):Null<Point<Float>> {
        if (paralell(line1, line2) || equivalent(line1, line2)) return null;
        
        var d = det(line1.a, line1.b, line2.a, line2.b);
        return new Point<Float>(
            -det(line1.c, line1.b, line2.c, line2.b) / d,
            -det(line1.a, line1.c, line2.a, line2.c) / d
        );
    }

    public static function distTo<T:Float, P:Point<T>>(p1:P, p2:P):Float {
        return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
    }
}