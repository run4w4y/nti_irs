package trik.robot.display;

import trik.robot.display.Display;
import trik.robot.display.Pixel;
import trik.robot.display.Rectangle;
import trik.robot.display.Line;
import trik.color.Color;
import trik.color.ColorTools.*;


abstract DisplayHigher(Display) {
    public function new():Void {
        this = untyped __js__("brick.display()");
    }

    public function addLabel(text:String, pixel:Pixel):Void {
        this.addLabel(text, pixel.x, pixel.y);
    }

    public function drawArc(rect:Rectangle, from:Int, to:Int):Void {
        this.drawArc(rect.points[0].x, rect.points[0].y, rect.length, rect.height, from, to);
    }

    public function drawEllipse(rect:Rectangle):Void {
        this.drawEllipse(rect.points[0].x, rect.points[0].y, rect.length, rect.height);
    }

    public function drawLine(line:Line):Void {
        this.drawLine(line.first.x, line.first.y, line.second.x, line.second.y);
    }

    public function drawPixel(pixel:Pixel):Void {
        this.drawPoint(pixel.x, pixel.y);
    }

    public function drawRect(rect:Rectangle):Void {
        this.drawRect(rect.points[0].x, rect.points[0].y, rect.length, rect.height);
    }

    public function setBackground(color:Color):Void {
        try 
            this.setBackground(colorToNativeText(color))
        catch (err:String)
            throw "unacceptable color format for the setBackground function";
    }

    public function setPainterColor(color:Color):Void {
        try 
            this.setPainterColor(colorToNativeText(color))
        catch (err:String)
            throw "unacceptable color format for the setPainterColor function";
    }
}