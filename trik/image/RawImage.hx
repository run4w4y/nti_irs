package trik.image;

import trik.color.Color;
import trik.color.ColorTools.*;
import trik.image.Image;
import Std;


abstract RawImage(Array<Color>) {
    public function new(raw_photo:String):Void {
        this = [for (i in 0...raw_photo.length) RGB24(Std.parseInt(raw_photo.charAt(i)))];
    }

    public function toImage():Image {
        var w = 160, h = 120;
        var res:Array<Array<Color>> = [];
        for (i in 0...h) {
            var tmp:Array<Color> = [];
            for (j in 0...w)
                tmp.push(colorToRgb(this[w * i + j]));
            res.push(tmp);
        }
        return new Image(res);
    }
}
