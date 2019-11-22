package trik.image;

import trik.color.Color;
import trik.tools.ColorTools.*;


@:forward
abstract Image(Array<Array<Color>>) {
    public function new(pixels:Array<Array<Color>>) {
        for (i in pixels) 
            if (i.length != pixels[0].length)
                throw "all row arrays must have the same length";

        this = pixels;
    }

    @:arrayAccess
    public inline function get(index:Int):Array<Color> {
        return this[index];
    }

    @:arrayAccess
    public inline function set(index:Int, val:Array<Color>):Array<Color> {
        this[index] = val;
        return val;
    }
}