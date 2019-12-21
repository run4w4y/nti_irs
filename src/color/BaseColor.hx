package color;

import color.Color;


class BaseColor implements Color {
    var rgbValue:Null<RGB> = null;
    @:isVar public var r(dynamic, null):Int;
    @:isVar public var g(dynamic, null):Int;
    @:isVar public var b(dynamic, null):Int;

    function calculateRGB():Void {};

    function get_r():Int {
        calculateRGB();
        return rgbValue.r;
    }

    function get_g():Int {
        calculateRGB();
        return rgbValue.g;
    }

    function get_b():Int {
        calculateRGB();
        return rgbValue.b;
    }

    public function toString():String {
        return 'BaseColor()';
    }
}