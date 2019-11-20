package trik.geometry;

class Point {
    var x:Int;
    var y:Int;

    public function new( ?x:Int = 0, ?y:Int = 0 ) {
        this.x = x;
        this.y = y;
    }

    public function toString() {
        return "Point(" + x + "," + y + ")";
    } 
}