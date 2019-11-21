package trik.geometry;

import Math.*;


class Point3D {
    public var x:Float;
    public var y:Float;
    public var z:Float;

    public function new( ?x:Float=0, ?y:Float=0, ?z:Float=0 ) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public function distTo(point:Point3D):Float {
        return sqrt(pow(point.x - this.x, 2) + pow(point.y - this.y, 2) + pow(point.z - this.z, 2));
    }
}