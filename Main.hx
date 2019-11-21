import trik.robot.motor.Motor;
import trik.Trik.*;
import trik.color.Color;
import trik.color.ColorTools.*;
import trik.robot.keys.Key;

using Lambda;

class Main {
    public static function main():Void {
        script.wait(3000);
        print(brick.keys.wasPressed(Left));
    }
}