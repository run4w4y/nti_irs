package trik.tools;

import trik.geometry.Line;
import trik.geometry.Point;
import trik.geometry.Vector;
import trik.geometry.PointLike;
import Math.*;


class GeometryTools {
    @:generic
    public static function distToLine<T:PointLike>(pointLike:T, line:Line) {
        var d:Float = line.point1.distTo(line.point2);
        var vector = Vector.fromPointLike(pointLike);
        var s:Float = (vector.sub(line.point1)).vector_product(vector.sub(line.point2));
        return abs(s)/d;
    }

    static function det(line1:Line, line2:Line):Float {
        return line1.a * line2.b - line1.b * line2.a;
    }

    public static function getIntersectionPoint(line1:Line, line2:Line):Point {
        var zn:Float = det(line1, line2);

        return new Point();
    }
}