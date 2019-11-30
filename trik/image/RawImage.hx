package trik.image;

import trik.color.RGBColor;
import trik.color.RGB24Color;
import trik.tools.ColorTools.*;
import trik.image.Image;


abstract RawImage(Array<RGB24Color>) {
    public function new(raw_photo:String):Void {
        this = [for (i in 0...raw_photo.length) new RGB24Color(Std.parseInt(raw_photo.charAt(i)))];
    }

    public function toImage():Image<RGBColor> {
        var w = 160, h = 120;
        var res:Array<Array<RGBColor>> = [];
        for (i in 0...h) {
            var tmp:Array<RGBColor> = [];
            for (j in 0...w)
                tmp.push(toRGB(this[w * i + j]));
            res.push(tmp);
        }
        return new Image(res);
    }
}
