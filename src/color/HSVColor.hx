package src.color;

import src.color.Color;
import src.exceptions.ValueException;


class HSVColor implements Color {
    public var h:Float;
    public var s:Float;
    public var v:Float;
    public var r:Null<Int>;
    public var g:Null<Int>;
    public var b:Null<Int>;
    
    public function new(h:Float, s:Float, v:Float):Void {
        if (h < 0 || h > 360) 
            throw new ValueException("h value must be within the range [0; 360]");
        if (s < 0 || s > 1) 
            throw new ValueException("s value must be within the range [0; 1]");
        if (v < 0 || v > 1) 
            throw new ValueException("v value must be within the range [0; 1]");

        this.h = h;
        this.s = s;
        this.v = v;
    }

    public function toString():String {
        return 'HSVColor($h, $s, $v)';
    }
}