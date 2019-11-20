import trik.geometry.Point;
import trik.robot.Brick;
import trik.robot.sensor.Sensor;

class Main {
    public static function main():Void {
        var brick = new Brick();
        var pt:Point = new Point(1, 2);
        var sensor:Sensor = brick.sensor("A1");
        trace(pt.toString());
    }
}