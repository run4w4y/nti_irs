package src.trik.robot.display;

import src.trik.geometry.Point;


class Pixel {
    public var x:Int;
    public var y:Int;

    public function new( ?x:Int=0, ?y:Int=0 ):Void {
        if (x < 0 || x > 240) 
            throw "x value must be in the range [0; 240]";
        if (y < 0 || y > 320)
            throw "y value must be in the range [0; 320]";
        
        this.x = x;
        this.y = y;
    }
}