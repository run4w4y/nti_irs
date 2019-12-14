package trik.image;

class Pixel {
    public var x:Int;
    public var y:Int;
    public var constraintsX:Null<Int>;
    public var constraintsY:Null<Int>;

    function constrain() {
        this.x = if (this.x < 0) 0 else this.x;
        this.y = if (this.y < 0) 0 else this.y;
        if (this.constraintsX != null && this.x > this.constraintsX) 
            this.x = this.constraintsX;
        if (this.constraintsY != null && this.y > this.constraintsY) 
            this.y = this.constraintsY;
    }

    public function new(x:Int, y:Int, ?constraintsX:Int, ?constraintsY:Int):Void {
        this.x = x;
        this.y = y;
        this.constraintsX = constraintsX;
        this.constraintsY = constraintsY;
        this.constrain();
    }

    public function add(pixel:Pixel):Void {
        this.x += pixel.x; 
        this.y += pixel.y;
        this.constrain();
    }

    public function toString():String {
        return 'Pixel($x, $y)';
    }
}