package robotModel.motorManager;

import Math.*;
import time.Time;
import trik.Brick;
import trik.Script;
import robotModel.motorManager.BaseManager;
import robotModel.motorManager.MotorManager;
import robotModel.speedManager.pid.PID;
import robotModel.speedManager.pid.PIDSim;
import robotModel.speedManager.pid.PIDCoefficients;
import robotModel.speedManager.SineAcceleration;

using tools.NullTools;
using tools.TimeTools;
using science.ScientificTools;


class RealManager extends BaseManager implements MotorManager {
    static var iLeft:Int = 0;
    static var iRight:Int = 0;
    static var imgKs:PIDCoefficients = {
        kp: 1.15,
        kd: 1.7
    };
    static var iLPid = new PID(-100, 100, imgKs);
    static var iRPid = new PID(-100, 100, imgKs);
    static var wallPid = new PID(-100, 100, {
        kp: .2,
        kd: .4
    });

    function alignImaginaryEncoders():Void {
        var uL = iLPid.calculate(iLeft - readLeft());
        var uR = iRPid.calculate(iRight - readRight());
        startLeft(round(uL));
        startRight(round(uR));
    }

    public function turn(angle:Float):Void {
        angle %= 360;
        if (angle > 180)
            angle -= 360;
        if (angle < -180)
            angle += 360;

        iRight = 0;
        iLeft = 0;
        resetEncoders();
        currentDirection += angle;
        var sign = angle.sign();
        var step = 3;
        var path = round(225 * abs(angle) / 90);
        var curR = iRight;
        var curL = iLeft;

        var t = Script.time();
        while (Script.time().getDifference(t) < 800)
            alignImaginaryEncoders();

        if (sign < 0) {
            while (iRight < curR + path) {
                iRight += step;
                iLeft -= step;
                alignImaginaryEncoders();
            }
            iRight = curR + path;
            iLeft = curL - path;
        } else { 
            while (iLeft < curL + path) {
                iRight -= step;
                iLeft += step;
                alignImaginaryEncoders();
            }
            iRight = curR - path;
            iLeft = curL + path;
        }

        var t = Script.time();
        while (Script.time().getDifference(t) < 1000)
            alignImaginaryEncoders();

        currentDirection = readGyro();
    }

    public function goEncoders(path:Int, ?accelPoint:Int, ?decelPoint:Int):Void {
        // Gyro + walls
        var accel = new SineAcceleration(40, 90, accelPoint, decelPoint, path);
        resetEncoders();
        var pidWalls = new PID(-100, 100, {
            kp: 6.5,
            kd: 5.5
        });
        var pidGyro = new PID(-100, 100, {
            kp: 4.25,
            kd: 2.65,
            ki: .0009
        });

        var curPath:Float;
        do {
            curPath = (readRight() + readLeft()) / 2;
            var v = accel.calculate(curPath);
            var l = sensorManager.checkLeft(), r = sensorManager.checkRight();
            var u:Float = 0;

            if (r)
                u = pidWalls.calculate(13 - sensorManager.rightSensor.read());
            else if (l)
                u = pidWalls.calculate(sensorManager.leftSensor.read() - 13);
            u += pidGyro.calculate(readGyro() - currentDirection);

            startLeft(round(v - u));
            startRight(round(v + u));
            
            Script.wait(Seconds(.01));
        } while (curPath <= path);

        stop(Seconds(0.1));
    }

    public inline function goMillimeters(length:Int, ?acceleratiion = false):Void {
        goEncoders(round(mmToEnc(length)));
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
}