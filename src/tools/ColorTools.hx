package tools;

import color.Color;
import color.LiteralColor;
import color.RGBColor;
import color.HSVColor;
import color.RGB24Color;
import color.MonoColor;
import color.BinaryColor;
import geometry.Point3D;
import ordering.Ordering;
import exceptions.TypeException;
import Math.*;

using Lambda;


class ColorTools {
    public static function toRGB(color:Dynamic):RGBColor {
        switch (Type.getClass(color)) {
            case RGBColor:
                return color;
            case RGB24Color:
                return new RGBColor(
                    (color.value & 16711680) >> 16, 
                    (color.value & 65280) >> 8, 
                    color.value & 255
                );
            case MonoColor:
                return new RGBColor(color.value, color.value, color.value);
            case HSVColor:
                var h = color.h;
                var s = color.s;
                var v = color.v;
                var fH = max(0, min(360, h))/60;
                var fS = max(0, min(1, s));
                var fV = max(0, min(1, v));

                if (fS == 0)
                    return new RGBColor(
                        round(v * 255),
                        round(v * 255),
                        round(v * 255)
                    );
                
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
                
                return new RGBColor(
                    round(res[0] * 255), 
                    round(res[1] * 255), 
                    round(res[2] * 255)
                );
            case BinaryColor:
                if (color.value)
                    return new RGBColor(0, 0, 0);
                else
                    return new RGBColor(255, 255, 255);
            case _:
                throw new TypeException("unknown color class was passed to the generic function colorToRgb");
        }
    }

    public static function toHSV(color:Dynamic):HSVColor {
        switch (Type.getClass(color)) {
            case HSVColor:
                return color;
            case _:
                var rgbColor = toRGB(color);
                var r = rgbColor.r;
                var g = rgbColor.g;
                var b = rgbColor.b;
                var fR = r/255;
                var fG = g/255;
                var fB = b/255;
                
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
    }

    public static function toMono(color:Dynamic):MonoColor {
        switch (Type.getClass(color)) {
            case MonoColor:
                return color;
            case _:
                var rgbColor = toRGB(color);
                return new MonoColor(floor((rgbColor.r + rgbColor.g + rgbColor.b) / 3));
        }
    }

    public static function toPoint3D(color:Dynamic):Point3D {
        var rgbColor = toRGB(color);
        return new Point3D(rgbColor.r, rgbColor.g, rgbColor.b);
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