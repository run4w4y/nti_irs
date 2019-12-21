package color;

import color.Color;
import constraints.Constraints.*;


class RGBColor implements Color {
    @:isVar public var r(get, null):Int;
    @:isVar public var g(get, null):Int;
    @:isVar public var b(get, null):Int;

    function get_r():Int return r;
    function get_g():Int return g;
    function get_b():Int return b;

    public function new(r:Int, g:Int, b:Int) {
        for (i in [r, g, b])
            checkRange(i, 0, 255);

        this.r = r;
        this.g = g;
        this.b = b;
    }

    public function toString():String {
        return 'RGBColor($r, $g, $b)';
    }
}