package robotModel.motorManager;

import Math.*;
import time.Time;
import trik.Brick;
import trik.Script;
import trik.robot.sensor.Sensor;
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
        kp: .1,
        kd: .2
    });

    function alignImaginaryEncoders():Void {
        var uL = iLPid.calculate(iLeft - readLeft());
        var uR = iRPid.calculate(iRight - readRight());
        startLeft(round(uL));
        startRight(round(uR));
    }

    public function turn(angle:Float):Void {
        
        angle = angle % 360;
        if(angle > 180)
           angle = angle - 360;
        if(angle < 180)
            angle = angle + 360;

        iRight = 0;
        iLeft = 0;
        resetEncoders();
        currentDirection += angle;
        var sign = angle.sign();
        var step = 3;
        var path = round(228 * abs(angle) / 90);
        var curR = iRight;
        var curL = iLeft;

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
        while (Script.time().getDifference(t) < 2000) {
            alignImaginaryEncoders();
        }
        currentDirection = readGyro();
    }

    function wallDriveRight():Void {
        var u = wallPid.calculate(13.5 - readRightSensor());
        iRight += round(8 + u);
        iLeft += round(8 - u);
        Script.wait(Seconds(.01));
        alignImaginaryEncoders();
    }

    function wallDriveLeft():Void {
        var u = wallPid.calculate(13.5 - readLeftSensor());
        iRight += round(8 - u);
        iLeft += round(8 + u);
        Script.wait(Seconds(.01));
        alignImaginaryEncoders();
    }

    function movePoint(path:Int):Void {
        var resetL = iLeft;
        var resetR = iRight;
        do {
            var curLeft = readLeftSensor();
            var curRight = readRightSensor();
            if (curLeft < 20)
                wallDriveLeft();
            else if (curRight < 20) 
                wallDriveRight();
            else {
                iLeft += 8;
                iRight += 8;
                alignImaginaryEncoders();
                Script.wait(Seconds(.01));
            }
        } while ((Math.abs(iLeft - resetL) + Math.abs(iRight - resetR)) / 2 < path);
    }

    public function goEncoders(path:Int, ?accelPoint:Int, ?decelPoint:Int):Void {
        movePoint(path);
        return;
        var accel = new SineAcceleration(40, 60, accelPoint, decelPoint, path);
        resetEncoders();
        var pidWalls = new PID(-100, 100, {
            kp: 15,
            kd: 30
        });
        var pidGyro = new PID(-100, 100, {
            kp: 4.75,
            kd: 2.65,
            ki: .0025
        });

        var curPath:Float;
        do {
            curPath = (readRight() + readLeft()) / 2;
            var v = accel.calculate(curPath);
            var l = checkLeft(), r = checkRight();
            var u:Float;

            // if (r)
            //     u = pidWalls.calculate(13 - readRightSensor());
            // else if (l)
            //     u = pidWalls.calculate(readLeftSensor() - 13);
            // else 
                u = pidGyro.calculate(readGyro() - currentDirection);

            startLeft(round(v - u));
            startRight(round(v + u));
            
            Script.wait(Seconds(.05));
        } while (curPath <= path);

        stop(Seconds(0.1));
    }

    public inline function goMillimeters(length:Int, ?acceleratiion = false):Void {
        goEncoders(round(mmToEnc(length)));
    }

    function checkSensor(sensor:Sensor):Bool {
        return readSensor(sensor) <= 17;
    }

    inline function checkLeft():Bool {
        return checkSensor(leftSensor);
    }

    inline function checkRight():Bool {
        return checkSensor(rightSensor);
    }

    @:updateFrequency(10)
    inline function readSensor(sensor:Sensor):Int {
        return sensor.read();
    }
    
    inline function readLeftSensor():Int {
        return readSensor(leftSensor);
    }

    inline function readRightSensor():Int {
        return readSensor(rightSensor);
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