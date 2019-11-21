package trik.color;

import trik.color.Color;
import trik.geometry.Point3D;


class ColorTools {
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

    public static function rgb24ToRgb(rgb24_value:Color):Color {
        switch (rgb24_value) {
            case RGB24(val):
                return return RGB(
                    (val & 16711680) >> 16, 
                    (val & 65280) >> 8, 
                    val & 255
                );
            case _:
                throw "wrong color format was passed, expected to get RGB24 value";
        }
    }

    public static function colorToRgb(color:Color):Color {
        var colorMatch:Map<Color, Color> = [
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

        if (!colorMatch.exists(color))
            throw "wrong color format was passed to the function";
        return colorMatch[color];
    }

    public static function colorToPoint3D(color):Point3D {
        switch (color) {
            case RGB(r, g, b):
                return new Point3D(r, g, b);
            case RGB24(_):
                return colorToPoint3D(rgb24ToRgb(color));
            case _:
                return colorToPoint3D(colorToRgb(color));
        }
    }

    public static function colorDist(color1:Color, color2:Color):Float {
        return colorToPoint3D(color1).distTo(colorToPoint3D(color2));
    }
}