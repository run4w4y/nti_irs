package color;

import color.BaseColor;
import exceptions.ValueException;

using tools.NullTools;


/**
    Class used to represent hexdec colors.
**/
class HexColor extends BaseColor {
    /**
        Hexdec string of the color.
    **/
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

    /**
        Class constructor.

        @param hex hexdec color, for example: 000000, 333333, FFFFFF
    **/
    public function new(hex:String) {
        if (hex.length != 6)
            throw new ValueException("hex string must be of length 6");

        value = hex;
    }

    override public function toString():String {
        return 'HexColor($value)';
    } 
}