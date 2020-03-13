package color;

import color.BaseColor;

using tools.NullTools;


/**
    Class that can be used to represent only two colors: white and black.
**/
class BinaryColor extends BaseColor {
    override function calculateRGB():Void {
        rgbValue = rgbValue.coalesce(
            if (value)
                {r: 0, g: 0, b: 0}
            else 
                {r: 255, g: 255, b: 255}
        );
    }

    /**
        Value of the color. False if the color is white, true if the color is black.
    **/
    public var value:Bool; // 0 - white, 1 - black

    /**
        Class constructor.

        @param value false if color is white, true if color is black.
    **/
    public function new(value:Bool):Void {
        this.value = value;
    }

    /**
        Inverses the color. White to black and vice versa.
    **/
    public function inverse():BinaryColor {
        return new BinaryColor(!this.value);
    }

    override public function toString():String {
        return 'BinaryColor($value)';
    }
}