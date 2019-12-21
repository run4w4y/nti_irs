package color;

import exceptions.ValueException;

using tools.NullTools;


class MonoColor extends BaseColor {
    public var value:Int;

    override function calculateRGB():Void {
        rgbValue = rgbValue.coalesce(
            {r: value, g: value, b: value}
        );
    }

    public function new(value:Int):Void {
        if (value < 0 || value > 255) 
            throw new ValueException("value of mono color has to be in the range [0; 255]");

        this.value = value;
    }

    override public function toString():String {
        return 'MonoColor($value)';
    }
}