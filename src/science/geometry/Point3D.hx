package science.geometry;

import Math.*;
import science.geometry.Point;


// implement operators
abstract Point3D<T:Float>(Array<T>) from Array<T> to Array<T> {
    public var x(get, set):T;
    public var y(get, set):T;
    public var z(get, set):T;

    private function get_x():T {
        return this[0];
    }

    private function set_x(value:T):T {
        return this[0] = value;
    }

    private function get_y():T {
        return this[1];
    }

    private function set_y(value:T):T {
        return this[1] = value;
    }

    private function get_z():T {
        return this[2];
    }

    private function set_z(value:T):T {
        return this[2] = value;
    }

    public function new(x:T, y:T, z:T) {
        this = [x, y, z];
    }

    public function distTo<T1:Float>(point:Point3D<T1>):Float {
        return sqrt(pow(point.x - x, 2) + pow(point.y - y, 2) + pow(point.z - z, 2));
    }

    @:from
    public static function fromPoint<T1:Float>(p:Point<T1>):Point3D<T1> {
        return new Point3D<T1>(p.x, p.y, p.x * 0);
    }

    @:to
    public function toPoint():Point<T> {
        return new Point<T>(x, y);
    }

    public function toString():String {
        return 'Point3d($x, $y, $z)';
    }
}