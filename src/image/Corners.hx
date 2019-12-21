package image;

import image.Pixel;


class Corners {
    public var leftTop:Pixel;
    public var rightTop:Pixel;
    public var rightBottom:Pixel;
    public var leftBottom:Pixel;

    public function new(?leftTop:Pixel, ?rightTop:Pixel, ?rightBottom:Pixel, ?leftBottom:Pixel) {
        this.leftTop = leftTop;
        this.rightTop = rightTop;
        this.rightBottom = rightBottom;
        this.leftBottom = leftBottom;
    }
}