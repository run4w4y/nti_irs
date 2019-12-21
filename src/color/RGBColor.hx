package color;

import color.Color;
import exceptions.ValueException;


class RGBColor implements Color {
    @:isVar public var r(get, null):Int;
    @:isVar public var g(get, null):Int;
    @:isVar public var b(get, null):Int;

    function get_r():Int return r;
    function get_g():Int return g;
    function get_b():Int return b;

    public function new(r:Int, g:Int, b:Int) {
        if (r < 0 || r > 255) 
            throw new ValueException("r value must be in the range [0; 255]");
        if (g < 0 || g > 255) 
            throw new ValueException("g value must be in the range [0; 255]");
        if (b < 0 || b > 255) 
            throw new ValueException("b value must be in the range [0; 255]");

        this.r = r;
        this.g = g;
        this.b = b;
    }

    public function toString():String {
        return 'RGBColor($r, $g, $b)';
    }
}