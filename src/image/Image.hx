package image;

import color.Color;
import science.matrix.Matrix;
import exceptions.ValueException;


@:forward
abstract Image<C:Color>(Matrix<C>) from Matrix<C> to Matrix<C> {
    public function new(pixels:Matrix<C>) {
        for (i in pixels) 
            if (i.length != pixels[0].length)
                throw new ValueException("all row arrays must have the same length");

        this = pixels;
    }

    public inline function at(?x:Int=0, ?y:Int=0):C {
        return this[y][x];
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