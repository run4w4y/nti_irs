import trik.robot.motor.Motor;
import trik.Trik.*;

using Lambda;

class Main {
    public static function main():Void {
        var motors = ["M3", "M4"].map(brick.motor);
        for (motor in motors)
            motor.setPower(100);
        script.wait(1000);
        print(10);
    }
}