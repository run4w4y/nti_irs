package trik.angle;

class Angle {
    public var value:Float;

    public function new(value:Float) {
        this.value = value % 360;
    }

    public function getDelta(degrees:Angle):Float {
        return (this.value - degrees.value + 900) % 360 - 180;
    }
}