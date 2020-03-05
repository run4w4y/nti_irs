package color;

import color.Color;


/**
    Class used as the base for all the other colors. 
**/
class BaseColor implements Color {
    var rgbValue:Null<RGB> = null;
    /**
        Calculates (if haven't yet been calculated) and returns the R value of the RGB representation of this color.
    **/
    @:isVar public var r(dynamic, null):Int;
    /**
        Calculates (if haven't yet been calculated) and returns the G value of the RGB representation of this color.
    **/
    @:isVar public var g(dynamic, null):Int;
    /**
        Calculates (if haven't yet been calculated) and returns the B value of the RGB representation of this color.
    **/
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