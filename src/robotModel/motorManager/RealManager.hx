package robotModel.motorManager;

import Math.*;
import trik.Brick;
import trik.Script;
import robotModel.motorManager.BaseManager;
import robotModel.motorManager.MotorManager;
import robotModel.speedManager.pid.PID;


class RealManager extends BaseManager implements MotorManager {
    public function turn(angle:Float):Void {
        currentDirection += angle;

        var pid = new PID(Seconds(.05), -50, 50, {
            kp: 17.5,
            kd: 12.3
        });
        move(
            0, 
            pid,
            function () 
                return Brick.gyroscope.read() - currentDirection,
            function() {
                var error = Brick.gyroscope.read() - currentDirection;
                return abs(error) > 0.1;
            }, 
            Seconds(.05)
        );
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