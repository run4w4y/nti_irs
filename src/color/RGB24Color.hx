package color;

import color.BaseColor;

using tools.NullTools;


class RGB24Color extends BaseColor {
    public var value:Int;

    override function calculateRGB():Void {
        rgbValue = rgbValue.coalesce({
            r: (value & 16711680) >> 16, 
            g: (value & 65280) >> 8, 
            b: value & 255
        });
    }

    public function new(value:Int) {
        this.value = value;
    }

    override public function toString():String {
        return 'RGB24Color($value)';
    }
}