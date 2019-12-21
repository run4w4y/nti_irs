package color;

import exceptions.ValueException;
import constraints.Constraints.*;

using tools.NullTools;


class MonoColor extends BaseColor {
    public var value:Int;

    override function calculateRGB():Void {
        rgbValue = rgbValue.coalesce(
            {r: value, g: value, b: value}
        );
    }

    public function new(value:Int):Void {
        checkRange(value, 0, 255);
        this.value = value;
    }

    override public function toString():String {
        return 'MonoColor($value)';
    }
}