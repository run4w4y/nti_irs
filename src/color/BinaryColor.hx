package color;

import color.BaseColor;

using tools.NullTools;


class BinaryColor extends BaseColor {
    override function calculateRGB():Void {
        rgbValue = rgbValue.coalesce(
            if (value)
                {r: 255, g: 255, b: 255}
            else 
                {r: 0, g: 0, b: 0}
        );
    }

    public var value:Bool; // 0 - white, 1 - black

    public function new(value:Bool):Void {
        this.value = value;
    }

    public function inverse():BinaryColor {
        return new BinaryColor(!this.value);
    }

    override public function toString():String {
        return 'BinaryColor($value)';
    }
}