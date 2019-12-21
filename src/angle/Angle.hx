package angle;

class Angle {
    public var value:Float;

    public function new(value:Float) {
        this.value = (360 + value) % 360;
    }

    public function add(angle:Float):Angle {
        return new Angle(this.value + angle);
    }

    public function getDelta(angle:Angle):Float {
        return (this.value - angle.value + 900) % 360 - 180;
    }

    public function toString():String {
        return 'Angle($value)';
    }
}