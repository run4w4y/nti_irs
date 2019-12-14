package trik.image;

import trik.image.Pixel;


class Corners {
    public var leftTop:Null<Pixel>;
    public var rightTop:Null<Pixel>;
    public var rightBottom:Null<Pixel>;
    public var leftBottom:Null<Pixel>;

    public function new(?leftTop:Null<Pixel>, ?rightTop:Null<Pixel>, ?rightBottom:Null<Pixel>, ?leftBottom:Null<Pixel>) {
        this.leftTop = leftTop;
        this.rightTop = rightTop;
        this.rightBottom = rightBottom;
        this.leftBottom = leftBottom;
    }
}