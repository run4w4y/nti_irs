package src.trik.image;

import src.trik.color.Color;
import src.trik.tools.ColorTools.*;


@:forward
abstract Image<C:Color>(Array<Array<C>>) {
    public function new(pixels:Array<Array<C>>) {
        for (i in pixels) 
            if (i.length != pixels[0].length)
                throw "all row arrays must have the same length";

        this = pixels;
    }

    @:arrayAccess
    public inline function get(index:Int):Array<C> {
        return this[index];
    }

    @:arrayAccess
    public inline function set(index:Int, val:Array<C>):Array<C> {
        this[index] = val;
        return val;
    }
}