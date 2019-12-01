package trik.angle;

class Angle {
    public var value:Float;

    public function new(value:Float) {
        this.value = value % 360;
    }

    public function add(angle:Angle):Angle {
        return new Angle(this.value + angle.value);
    }

    public function getDelta(angle:Angle):Float {
        return (this.value - angle.value + 900) % 360 - 180;
    }
}