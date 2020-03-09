package color;

import color.RGBColor;


/**
    Class for assigning some name to an RGB color.
**/
class LiteralColor extends RGBColor {
    public var name:String;

    /**
        Class constructor.

        @param r R value of the color
        @param g G value of the color
        @param b B value of the color
        @param name name of the color
    **/
    public function new(r:Int, g:Int, b:Int, name:String):Void {
        super(r, g, b);
        this.name = name;
    }

    override public function toString():String {
        return 'LiteralColor($name)';
    }
}