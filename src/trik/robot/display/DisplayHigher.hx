package .robot.display;

import .robot.display.Display;
import .robot.display.Pixel;
import .robot.display.Rectangle;
import .robot.display.Line;
import r.LiteralColor;


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
        this.drawLine(line.first.x, line.first.y, line.second.x, line.second.y);
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