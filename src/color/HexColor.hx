package color;

import color.BaseColor;
import exceptions.ValueException;

using tools.NullTools;


class HexColor extends BaseColor {
    public var value:String;

    function hexToInt(str:String) {
        return Std.parseInt('0x$str');
    }

    override function calculateRGB():Void {
        rgbValue = rgbValue.coalesce({
            r: hexToInt(value.substr(0, 2)),
            g: hexToInt(value.substr(2, 2)),
            b: hexToInt(value.substr(4, 2))
        });
    }

    public function new(hex:String) {
        if (hex.length != 6)
            throw new ValueException("hex string must be of length 6");

        value = hex;
    }

    override public function toString():String {
        return 'HexColor($value)';
    } 
}