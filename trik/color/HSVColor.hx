package trik.color;

import trik.color.Color;


class HSVColor implements Color {
    public var h:Float;
    public var s:Float;
    public var v:Float;
    public var r:Null<Int>;
    public var g:Null<Int>;
    public var b:Null<Int>;
    
    public function new(h:Float, s:Float, v:Float):Void {
        if (h < 0 || h > 360) throw "h value must be in the range [0; 360]";
        if (s < 0 || s > 1) throw "s value must be in the range [0; 1]";
        if (v < 0 || v > 1) throw "v value must be in the range [0; 1]";

        this.h = h;
        this.s = s;
        this.v = v;
    }

    public function toString():String {
        return 'HSVColor($h, $s, $v)';
    }
}