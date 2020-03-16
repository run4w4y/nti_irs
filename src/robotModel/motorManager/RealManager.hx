package robotModel.motorManager;

import Math.*;
import trik.Brick;
import trik.Script;
import robotModel.motorManager.BaseManager;
import robotModel.motorManager.MotorManager;
import robotModel.speedManager.pid.PID;


class RealManager extends BaseManager implements MotorManager {
    public function turn(angle:Float):Void {
        resetEncoders();
        currentDirection += angle;

        var v = 35;
        var kLeft = if (angle < 0) -1 else 1;
        var kRight = if (angle < 0) 1 else -1;
        var pid = new PID(Seconds(.01), -100, 100, {
            kp: .8,
            kd: .6,
            ki: .002
        });

        while (abs(Brick.gyroscope.read() - currentDirection) > 0.75) {
            var u = pid.calculate(readRight() + readLeft());
            resetEncoders();
            Script.print('
                Left: ${round((v + u) * kLeft)}, u: $u
                Right: ${round((v - u) * kRight)}, u: ${-u}
                Gyro: ${currentDirection - Brick.gyroscope.read()}
            ');

            if (angle < 0) {
                startLeft(round((v + u) * kLeft));
                startRight(round((v - u) * kRight));
            } else {
                startLeft(round((v - u) * kLeft));
                startRight(round((v + u) * kRight));
            }

            Script.wait(Seconds(.01));
        }

        stop(Seconds(0.1));
    }

    public inline function turnLeft():Void {
        turn(-90);
    }

    public inline function turnRight():Void {
        turn(90);
    }

    public inline function turnAround():Void {
        turn(180);
    }

    public function goEncoders(encValue:Int, ?acceleration = false):Void {
        moveGyro(90, function () {
            return (readLeft() + readRight()) / 2 <= encValue;
        });
        stop(Seconds(0.1));
    }

    public inline function goMillimeters(length:Int, ?acceleratiion = false):Void {
        goEncoders(round(mmToEnc(length)));
    }
}