package src.image;

import src.color.Color;
import src.tools.ColorTools.*;
import src.exceptions.ValueException;


@:forward
abstract Image<C:Color>(Array<Array<C>>) {
    public function new(pixels:Array<Array<C>>) {
        for (i in pixels) 
            if (i.length != pixels[0].length)
                throw new ValueException("all row arrays must have the same length");

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