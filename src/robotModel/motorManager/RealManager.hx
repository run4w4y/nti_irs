package robotModel.motorManager;

import Math.*;
import time.Time;
import trik.Brick;
import trik.Script;
import trik.robot.sensor.Sensor;
import robotModel.motorManager.BaseManager;
import robotModel.motorManager.MotorManager;
import robotModel.speedManager.pid.PID;
import robotModel.speedManager.SineAcceleration;
import robotModel.control.MixedController;

using tools.NullTools;
using tools.TimeTools;


class RealManager extends BaseManager implements MotorManager {
    static var wallPID = new PID(-40, 40, {
        kp: 5.2,
        kd: 3.9,
        ki: .00005
    });

    public function turn(angle:Float):Void {
        currentDirection += angle;

        var pid = new PID(-60, 60, {
            kp: 4.5,
            kd: 3.5,
            ki: 0
        });

        var t = false;
        var prev = Script.time();
        move(
            0, 
            pid,
            function () 
                return Brick.gyroscope.read() - currentDirection,
            function() {
                var error = Brick.gyroscope.read() - currentDirection;
                var res = abs(error) < 1;
                if (res && !t)
                    t = true;
                else if (!t)
                    prev = Script.time();
                return !(t && Script.time().getDifference(prev) >= 1000);
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

    public function goEncoders(path:Int, ?accelPoint:Int, ?decelPoint:Int):Void {
        var accel = new SineAcceleration(30, 90, accelPoint, decelPoint, path);
        resetEncoders();

        var curPath:Float;
        do {
            curPath = (readRight() + readLeft()) / 2;
            var v = accel.calculate(curPath);
            moveMixed(round(v));
            Script.wait(Seconds(.05));
        } while (curPath <= path);

        stop(Seconds(0.1));
    }

    public function moveMixed(speed:Int, ?condition:Void -> Bool, ?interval:Time):Void {
        if (condition != null)
            wallPID = new PID(-40, 40, {
                kp: 12.3,
                kd: 9.7
            });
        do {
            var l = checkLeft(), r = checkRight();
            
            if (r)
                move(speed, wallPID, function () return 13 - rightSensor.read());
            else if (l)
                move(speed, wallPID, function () return leftSensor.read() - 13);
            else 
                moveGyro(speed);
            
            if (condition == null) 
                return;
            Script.wait(interval.coalesce(Seconds(.05)));
        } while (condition());
    }

    public inline function goMillimeters(length:Int, ?acceleratiion = false):Void {
        goEncoders(round(mmToEnc(length)));
    }

    function checkSensor(sensor:Sensor):Bool {
        return sensor.read() <= 17;
    }

    inline function checkLeft():Bool {
        return checkSensor(leftSensor);
    }

    inline function checkRight():Bool {
        return checkSensor(rightSensor);
    }
}