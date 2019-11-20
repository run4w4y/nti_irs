import trik.robot.Brick;
import trik.robot.Script;
import trik.robot.Mailbox;
import trik.robot.motor.Motor;

using Lambda;

class Main {
    public static function main():Void {
        var brick = new Brick();
        var script = new Script();
        var mailbox = new Mailbox();

        var motors = ["M3", "M4"].map(brick.motor);
        for (motor in motors)
            motor.setPower(100);
        script.wait(1000);
    }
}