package trik.tools;

import trik.color.Color;
import trik.color.ColorType;
import trik.geometry.Point3D;
import trik.ordering.Ordering;
import Math.*;

using Lambda;


class ColorTools {
    static var literalRgbMatch:Map<Color, Color> = [
        Red     => RGB(255, 0, 0),     DarkRed     => RGB(127, 0, 0),
        Green   => RGB(0, 255, 0),     DarkGreen   => RGB(0, 127, 0),
        Blue    => RGB(0, 0, 255),     DarkBlue    => RGB(0, 0, 127),
        Cyan    => RGB(0, 255, 255),   DarkCyan    => RGB(0, 127, 127),
        Magenta => RGB(255, 0, 255),   DarkMagenta => RGB(127, 0, 127),
        Yellow  => RGB(255, 255, 0),   DarkYellow  => RGB(127, 127, 0),
        Grey    => RGB(127, 127, 127), DarkGrey    => RGB(191, 191, 191), LightGrey => RGB(65, 65, 65),
        Black   => RGB(0, 0, 0),
        White   => RGB(255, 255, 255) 
    ];

    public static function colorToNativeText(color:Color):String {
        var colorMatch:Map<Color, String> = [
            Red     => "red",     DarkRed => "darkRed",
            Green   => "green",   DarkGreen => "darkGreen",
            Blue    => "blue",    DarkBlue => "darkBlue",
            Cyan    => "cyan",    DarkCyan => "darkCyan",
            Magenta => "magenta", DarkMagenta => "darkMagenta",
            Yellow  => "yellow",  DarkYellow => "darkYellow",
            Grey    => "grey",    DarkGrey => "darkGrey",       LightGrey => "lightGrey",
            Black   => "black"
        ];

        if (!colorMatch.exists(color))
            throw "no native string for the passed color is available";
        return colorMatch[color];
    }

    static function colorToRgb(color:Color):Color {
        switch (color) {
            case RGB(_, _, _):
                return color;
            case RGB24(val):
                return RGB(
                    (val & 16711680) >> 16, 
                    (val & 65280) >> 8, 
                    val & 255
                );
            case Mono(val):
                return RGB(val, val, val);
            case HSV(h, s, v):
                var fH = max(0, min(360, h))/60;
                var fS = max(0, min(1, s));
                var fV = max(0, min(1, s));

                if (fS == 0)
                    return RGB(
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
                
                return RGB(
                    round(res[0] * 255), 
                    round(res[1] * 255), 
                    round(res[2] * 255)
                );
            case _:
                if (!literalRgbMatch.exists(color))
                    throw "wrong color format was passed to the function";
                else 
                    return literalRgbMatch[color];
        }
    }

    static function rgbToHsv(color:Color):Color {
        var fR:Float, fG:Float, fB:Float;

        switch (color) {
            case RGB(r, g, b):
                fR = r/255;
                fG = g/255;
                fB = b/255;
            case _:
                throw "value is supposed to be of RGB constructor";
        }

        var minRGB = min(fR, min(fG, fB));
        var maxRGB = max(fR, max(fG, fB));

        if (minRGB == maxRGB)
            return HSV(0, 0, minRGB);

        var d = (fR == minRGB) ? fG - fB : ((fB == minRGB) ? fR - fG : fB - fR);
        var h = (fR == minRGB) ? 3 : ((fB == minRGB) ? 1 : 5);

        return HSV(
            60*(h - d/(maxRGB - minRGB)),
            (maxRGB - minRGB)/maxRGB,
            maxRGB
        );
    }

    static function rgbToMono(color:Color):Color {
        switch (color) {
            case RGB(r, g, b):
                return Mono(floor((r + g + b) / 3));
            case _:
                throw "value is supposed to be of RGB constructor";
        }
    }

    public static function convert(color:Color, targetColorType:CT):Color {
        var colorRgb = colorToRgb(color);

        switch (targetColorType) {
            case RGBType:
                return colorRgb;
            case HSVType:
                return rgbToHsv(colorRgb);
            case MonoType:
                return rgbToMono(colorRgb);
            case _:
                throw "cant convert color to this ColorType";
        }
    } 

    public static function colorToPoint3D(color:Color):Point3D {
        switch (color) {
            case RGB(r, g, b):
                return new Point3D(r, g, b);
            case _:
                return colorToPoint3D(colorToRgb(color));
        }
    }

    public static function colorDist(color1:Color, color2:Color):Float {
        return colorToPoint3D(color1).distTo(colorToPoint3D(color2));
    }

    public static function getValue(color:Color):Int {
        switch (color) {
            case Mono(value):
                return value;
            case RGB24(value):
                return value;
            case _:
                throw "cant extract value from color of constructors other than Mono and RGB24";
        }
    }

    public static function getColorType(color:Color):CT {
        switch (color) {
            case Mono(_):      return MonoType;
            case RGB24(_):     return RGB24Type;
            case RGB(_, _, _): return RGBType;
            case HSV(_, _, _): return HSVType;
            case _:            return LiteralType;
        }
    }

    public static function compareMono(color1:Color, color2:Color, ?threshold:Int=0):Ordering {
        var color1Mono = convert(color1, MonoType);
        var color2Mono = convert(color2, MonoType);

        if (getValue(color1Mono) < getValue(color2Mono))
            return LT;
        if (getValue(color1Mono) > getValue(color2Mono))
            return GT;
        return EQ;
    }

    public static function getRgb(color:Color):{r:Int, g:Int, b:Int} {
        switch (color) {
            case RGB(r, g, b):
                return {r: r, g: g, b: b};
            case _:
                throw "cant get r, g and b values from a color of not RGB constructor";
        }
    }

    public static function compare(color1:Color, color2:Color, ?threshold:Int=0):Bool {
        var color1Rgb = getRgb(convert(color1, RGBType));
        var color2Rgb = getRgb(convert(color2, RGBType));

        return abs(color1Rgb.r - color2Rgb.r) <= threshold && 
            abs(color1Rgb.g - color2Rgb.g) <= threshold && 
            abs(color1Rgb.b - color2Rgb.b) <= threshold;
    }
}