package src.trik.robot.display;

import src.trik.robot.display.Pixel;


class Rectangle {
    public var length:Int;
    public var height:Int;
    public var points:Array<Pixel>;

    public function new(pixel:Pixel, length:Int, height:Int):Void {
        try 
            this.points = [
                pixel,
                new Pixel(pixel.x + length, pixel.y),
                new Pixel(pixel.x + length, pixel.y + height),
                new Pixel(pixel.x, pixel.y + height)
            ]
        catch (err:String) 
            throw "rectangle doesnt fit in the screen";
        
        this.length = length;
        this.height = height;
    }
}