package image;

import color.RGBColor;
import color.RGB24Color;
import image.Image;

using tools.ColorTools;


class RawImage {
    var photo:Array<Int>;
    var w:Int;
    var h:Int;

    public function new(photo, ?w:Int = 160, ?h:Int = 120):Void {
        this.photo = photo;
        this.w = w;
        this.h = h;
    }

    public function toImage():Image<RGBColor> {
        var raw:Array<RGBColor> = [for (i in 0...photo.length) new RGB24Color(photo[i]).toRGB()];
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
