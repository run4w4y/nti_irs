package image;

import color.RGBColor;
import color.RGB24Color;
import color.HexColor;
import image.Image;

using StringTools;
using tools.NullTools;
using tools.ColorTools;


enum RawColorScheme {
    Rgb24;
    Hex;
}


class RawImage {
    var photoString:String;
    var w:Int;
    var h:Int;
    var colorScheme:RawColorScheme;

    public function new(rawString, ?colorScheme:RawColorScheme, ?w:Int = 160, ?h:Int = 120):Void {
        photoString = rawString;
        this.w = w;
        this.h = h;
        this.colorScheme = colorScheme.coalesce(Rgb24);
    }

    public function toImage():Image<RGBColor> {
        var raw:Array<RGBColor> = switch (colorScheme) {
            case Rgb24:
                [for (i in 0...photoString.length) new RGB24Color(Std.parseInt(photoString.charAt(i))).toRGB()];
            case Hex:
                photoString.trim().split(' ').map(function (a) return new HexColor(a).toRGB());
        };

        var res:Array<Array<RGBColor>> = [];

        for (i in 0...h) {
            var tmp:Array<RGBColor> = [];
            for (j in 0...w)
                tmp.push(raw[w * i + j]);
            res.push(tmp);
        }
        
        return new Image(res);
    }
}
