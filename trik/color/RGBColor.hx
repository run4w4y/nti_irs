package trik.color;

import trik.color.Color;


class RGBColor implements Color {
    public var r:Null<Int>;
    public var g:Null<Int>;
    public var b:Null<Int>;

    public function new(r:Int, g:Int, b:Int) {
        if (r < 0 || r > 255) throw "r value must be in the range [0; 255]";
        if (g < 0 || g > 255) throw "g value must be in the range [0; 255]";
        if (b < 0 || b > 255) throw "b value must be in the range [0; 255]";

        this.r = r;
        this.g = g;
        this.b = b;
    }

    public function toString():String {
        return 'RGBColor($r, $g, $b)';
    }
}