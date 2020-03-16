package robotModel.motorManager;

import Math.*;
import trik.Brick;
import trik.Script;
import robotModel.motorManager.BaseManager;
import robotModel.motorManager.MotorManager;


class SimulatorManager extends BaseManager implements MotorManager {
    public function turn(angle:Float):Void {
        currentDirection += angle;
        moveGyro(0, function() {
                return abs(currentDirection - cast(Brick.gyroscope.read())) > 1;
            }, Seconds(0.01), {kp: 1 }
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