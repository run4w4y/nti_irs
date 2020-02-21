package angle;

abstract Angle(Float) from Float to Float {
    public function new(value:Float) {
        this = (360 + value) % 360;
    }

    @:op(A + B)
    public function add(angle:Angle):Angle {
        return new Angle(this + cast(angle, Float));
    }

    @:op(A - B)
    public function getDelta(angle:Angle):Float {
        return (this - cast(angle, Float) + 900) % 360 - 180;
    }
}