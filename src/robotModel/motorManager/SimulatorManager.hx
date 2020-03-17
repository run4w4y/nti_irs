package robotModel.motorManager;

import Math.*;
import trik.Brick;
import trik.Script;
import time.Time;
import robotModel.speedManager.pid.PIDSim;
import robotModel.speedManager.pid.PIDCoefficients;
import robotModel.motorManager.BaseManager;
import robotModel.motorManager.MotorManager;

using tool.NullTools;


class SimulatorManager extends BaseManager implements MotorManager {
    static var gyroPID = new PIDSim(Seconds(.01), -100, 100, {
        kp: 1.05,
        kd: 0.4,
        ki: 0.0001
    });

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

    public function goEncoders(encValue:Int, ?_ :Int, ?_:Int):Void {
        moveGyro(90, function () {
            return (readLeft() + readRight()) / 2 <= encValue;
        });
        stop(Seconds(0.1));
    }

    public inline function goMillimeters(length:Int, ?acceleratiion = false):Void {
        goEncoders(round(mmToEnc(length)));
    }

    override function moveGyro(speed:Int, ?condition:(Void -> Bool), ?interval:Time, ?coefficients:PIDCoefficients):Void {
        var defaults:PIDCoefficients = {
            kp: 1.05,
            kd: 0.4,
            ki: 0.0001
        };
        if (condition != null)
            gyroPID = new PIDSim(interval.coalesce(Seconds(.01)), -100, 100, coefficients.coalesce(defaults));
        move(speed, gyroPID, function() {
                return Brick.gyroscope.read() - currentDirection;
            }, 
            condition, interval
        );
    }
}