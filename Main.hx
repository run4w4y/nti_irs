import trik.robot.motor.Motor;
import trik.Trik.*;
import trik.robot.keys.Key;

using Lambda;

class Main {
    public static function main():Void {
        // var motors = ["M3", "M4"].map(brick.motor);
        // for (motor in motors)
        //     motor.setPower(100);
        script.wait(3000);
        print(brick.keys.wasPressed(Left));
    }
}