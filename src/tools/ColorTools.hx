package tools;

import color.Color;
import color.LiteralColor;
import color.RGBColor;
import color.HSVColor;
import color.RGB24Color;
import color.MonoColor;
import color.BinaryColor;
import color.HexColor;
import geometry.Point3D;
import ordering.Ordering;
import exceptions.TypeException;
import Math.*;

using Lambda;


class ColorTools {
    public static function toRGB<T:Color>(color:T):RGBColor {
        return new RGBColor(
            color.r,
            color.g,
            color.b
        );
    }

    public static function toHSV<T:Color>(color:T):HSVColor {
        var fR = color.r/255;
        var fG = color.g/255;
        var fB = color.b/255;
        
        var minRGB = min(fR, min(fG, fB));
        var maxRGB = max(fR, max(fG, fB));

        if (minRGB == maxRGB)
            return new HSVColor(0, 0, minRGB);

        var d = (fR == minRGB) ? fG - fB : ((fB == minRGB) ? fR - fG : fB - fR);
        var h = (fR == minRGB) ? 3 : ((fB == minRGB) ? 1 : 5);

        return new HSVColor(
            60*(h - d/(maxRGB - minRGB)),
            (maxRGB - minRGB)/maxRGB,
            maxRGB
        );
    }

    public static function toMono<T:Color>(color:T):MonoColor {
        return new MonoColor(floor((color.r + color.g + color.b) / 3));
    }

    public static function toPoint3D<T:Color>(color:T):Point3D {
        return new Point3D(color.r, color.g, color.b);
    }

    public static function compareMono(color1:MonoColor, color2:MonoColor, ?threshold:Int=0):Ordering {
        if (color1.value < color2.value)
            return LT;
        if (color1.value > color2.value)
            return GT;
        return EQ;
    }

    public static function compare(color1:Dynamic, color2:Dynamic, ?threshold:Int=0):Bool {
        var color1Rgb = toRGB(color1);
        var color2Rgb = toRGB(color2);

        return abs(color1Rgb.r - color2Rgb.r) <= threshold && 
            abs(color1Rgb.g - color2Rgb.g) <= threshold && 
            abs(color1Rgb.b - color2Rgb.b) <= threshold;
    }
}