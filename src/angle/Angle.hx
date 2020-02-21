package angle;

/**
    Angle type for usage with gyroscope and such.
**/
abstract Angle(Float) from Float to Float {
    /**
        Angle abstract constructor.

        @param value angle value
    **/
    public function new(value:Float):Void {
        this = (360 + value) % 360;
    }

    /**
        Add up two angles. The result's value will be preserved in range from 0 to 360.

        @param angle angle to be added up
        @returns the sum angle
    **/
    @:op(A + B)
    public function add(angle:Angle):Angle {
        return new Angle(this + cast(angle, Float));
    }

    /**
        Get difference between two Angles. Result can be both positive and negative.

        @param angle 
        @returns delta between two angles
    **/
    @:op(A - B)
    public function getDelta(angle:Angle):Float {
        return (this - cast(angle, Float) + 900) % 360 - 180;
    }
}