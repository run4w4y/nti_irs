package trik.tools;

import trik.geometry.Line;
import trik.geometry.Point;
import trik.geometry.Vector;
import trik.geometry.PointLike;
import Math.*;


class GeometryTools {
    public static var epsilon = 1e-6;

    @:generic
    public static function distToLine<T:PointLike>(pointLike:T, line:Line) {
        var d:Float = distTo(line.point1, line.point2);
        var vector = Vector.fromPointLike(pointLike);
        var s:Float = (vector.sub(line.point1)).vector_product(vector.sub(line.point2));
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

    public static function getIntersectionPoint(line1:Line, line2:Line):Null<Point> {
        if (paralell(line1, line2) || equivalent(line1, line2)) return null;
        
        var d = det(line1.a, line1.b, line2.a, line2.b);
        return new Point(
            (line2.b * line1.c - line1.b * line2.c) / d,
            (line1.a * line2.c - line2.a * line1.c) / d
        );
    }

    @:generic
    public static function toPoint<T:PointLike>(pointLike:T):Point {
        return new Point(pointLike.x, pointLike.y);
    }

    @:generic
    public static function distTo<T:PointLike>(pointLike1:T, pointLike2:T):Float {
        return sqrt(pow(pointLike1.x - pointLike2.x, 2) + pow(pointLike1.y - pointLike2.y, 2));
    }
}