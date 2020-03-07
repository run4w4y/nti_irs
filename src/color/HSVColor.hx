package color;

import color.BaseColor;
import color.RGB;
import exceptions.ValueException;
import Math.*;
import constraints.Constraints.*;

using tools.NullTools;


/**
    Class used to store colors using HSV color model.
**/
class HSVColor extends BaseColor {
    public var h:Float;
    public var s:Float;
    public var v:Float;

    override function calculateRGB():Void {
        var fH = max(0, min(360, h))/60;
        var fS = max(0, min(1, s));
        var fV = max(0, min(1, v));
        var resRgb:RGB;

        if (fS == 0) {
            rgbValue = rgbValue.coalesce({
                r: round(v * 255),
                g: round(v * 255),
                b: round(v * 255)
            });
            return;
        }
        
        var i = floor(h);
        var f = h - i;
        var p = v * (1 - s);
        var q = v * (1 - s * f);
        var t = v * (1 - s * (1 - f));
        var res:Array<Float>;
        
        switch(i) {
            case 0:
                res = [v, t, p];
            case 1:
                res = [q, v, p];
            case 2:
                res = [p, v, t];
            case 3:
                res = [p, q, v];
            case 4:
                res = [t, p, v];
            case _:
                res = [v, p, q];
        }
        
        rgbValue = rgbValue.coalesce({
            r: round(res[0] * 255), 
            g: round(res[1] * 255), 
            b: round(res[2] * 255)
        });
    }
    
    /**
        Class constructor.

        @param h h value of the color
        @param s s value of the color
        @param v v value of the color
    **/
    public function new(h:Float, s:Float, v:Float):Void {
        checkRange(h, 0, 360);
        checkRange(s, 0, 1);
        checkRange(v, 0, 1);

        this.h = h;
        this.s = s;
        this.v = v;
    }

    override public function toString():String {
        return 'HSVColor($h, $s, $v)';
    }
}