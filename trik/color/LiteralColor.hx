package trik.color;

import trik.color.RGBColor;


class LiteralColor extends RGBColor {
    public var name:String;

    public function new(r:Int, g:Int, b:Int, name:String):Void {
        super(r, g, b);
        this.name = name;
    }
}