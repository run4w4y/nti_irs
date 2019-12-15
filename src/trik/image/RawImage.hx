package src.trik.image;

import src.trik.color.RGBColor;
import src.trik.color.RGB24Color;
import src.trik.tools.ColorTools.*;
import src.trik.image.Image;


abstract RawImage(Array<RGB24Color>) {
    public function new(rawPhoto:String):Void {
        this = [for (i in 0...rawPhoto.length) new RGB24Color(Std.parseInt(rawPhoto.charAt(i)))];
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
