package image;

import science.geometry.Point;


@:forward
abstract Pixel(Point<Int>) from Point<Int> to Point<Int> {
    public var x(get, set):Int;
    public var y(get, set):Int;

    private inline function get_x():Int {
        return this.x;
    }

    private inline function set_x(value:Int):Int {
        return this.x = value;
    }

    private inline function get_y():Int {
        return this.y;
    }

    private inline function set_y(value:Int):Int {
        return this.y = value;
    }

    public function new(x:Int, y:Int, ?constraintsX:Int, ?constraintsY:Int):Void {
        this = new Point<Int>(if (x < 0) 0 else x, if (y < 0) 0 else y);
        if (constraintsX != null && this.x > constraintsX) 
            this.x = constraintsX;
        if (constraintsY != null && this.y > constraintsY) 
            this.y = constraintsY;
    }
}