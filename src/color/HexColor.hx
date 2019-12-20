package src.color;

import src.color.RGBColor;
import src.exceptions.ValueException;


class HexColor extends RGBColor {
    public var hex:String;

    function hexToInt(str:String) {
        return Std.parseInt('0x$str');
    }

    public function new(hex:String) {
        if (hex.length != 6)
            throw new ValueException("hex string must be of length 6");

        super(
            hexToInt(hex.substr(0, 2)),
            hexToInt(hex.substr(2, 2)),
            hexToInt(hex.substr(4, 2))
        );
    }

    public function toRgb() {
        return new RGBColor(r, g, b);
    }
}