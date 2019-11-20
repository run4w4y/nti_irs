import trik.geometry.Point;
import trik.robot.Brick;

class Main {
    var brick = new Brick();

    public static function main():Void {
        var pt = new Point(1, 2);
        trace(pt.toString());
    }
}