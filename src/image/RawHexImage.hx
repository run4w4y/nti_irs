package image;

import image.Image;
import color.HexColor;
import color.RGBColor;

using StringTools;
using tools.ColorTools;


class RawHexImage {
    var photoString:String;
    var w:Int;
    var h:Int;

    public function new(rawString, ?w:Int = 160, ?h:Int = 120):Void {
        photoString = rawString;
        this.w = w;
        this.h = h;
    }

    public function toImage():Image<RGBColor> {
        var raw:Array<RGBColor> = photoString.trim().split(' ').map(function (a) return new HexColor(a).toRGB());
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