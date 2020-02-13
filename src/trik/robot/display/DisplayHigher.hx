package trik.robot.display;

import trik.robot.display.Display;
import image.Pixel;
import trik.robot.display.Rectangle;
import science.geometry.Line;
import color.LiteralColor;


@:forward
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
        var p1 = line.point1.round();
        var p2 = line.point2.round();
        this.drawLine(p1.x, p1.y, p2.x, p2.y);
    }

    public function drawPixel(pixel:Pixel):Void {
        this.drawPoint(pixel.x, pixel.y);
    }

    public function drawRect(rect:Rectangle):Void {
        this.drawRect(rect.points[0].x, rect.points[0].y, rect.length, rect.height);
    }

    public function setBackground(color:LiteralColor):Void {
        this.setBackground(color.name);
    }

    public function setPainterColor(color:LiteralColor):Void {
        this.setPainterColor(color.name);
    }
}