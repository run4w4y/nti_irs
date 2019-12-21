package color;

import color.RGBColor;


class LiteralColor extends RGBColor {
    public var name:String;

    public function new(r:Int, g:Int, b:Int, name:String):Void {
        super(r, g, b);
        this.name = name;
    }

    override public function toString():String {
        return 'LiteralColor($name)';
    }
}