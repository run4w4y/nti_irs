package robotModel.motorManager;

import angle.Angle;
import time.Time;
import trik.Brick;
import trik.Script;
import robotModel.motor.Motor;
import robotModel.speedManager.SpeedManager;
import robotModel.motorManager.ManagerArgs;
import robotModel.sensorManager.SensorManager;

using tools.NullTools;


class BaseManager {
    public var leftMotor:Motor;
    public var rightMotor:Motor;
    public var currentDirection:Angle;
    public var sensorManager:SensorManager;
    var wheelRadius:Float;
    var inversedVelocity:Bool;
    var inversedEncoders:Bool;

    public function new(args:ManagerArgs):Void {
        leftMotor = args.leftMotor;
        rightMotor = args.rightMotor;
        wheelRadius = args.wheelRadius;
        sensorManager = args.sensorManager;
        currentDirection = readGyro();
        resetEncoders();
    }

    inline function resetEncoders():Void {
        leftMotor.encoder.reset();
        rightMotor.encoder.reset();
    }

    function stop(?delayTime:Time):Void {
        delayTime = delayTime.coalesce(Milliseconds(0));
        this.leftMotor.setPower(0);
        this.rightMotor.setPower(0);
        Script.wait(delayTime);
    }

    inline function mmToEnc(length:Float):Float {
        return length / (2 * Math.PI * wheelRadius) * 360;
    }

    @:updateFrequency(50)
    inline function readGyro():Angle {
        return Brick.gyroscope.read();
    }

    function move(speed:Int, controller:SpeedManager, getError:Void -> Float, 
    ?condition:Void -> Bool, ?interval:Time):Void {
        interval = interval.coalesce(Seconds(0.1));
        
        do {
            var u = controller.calculate(getError());
            
            leftMotor.setPower(Math.round(speed - u));
            rightMotor.setPower(Math.round(speed + u));

            if (condition == null) return;
            Script.wait(interval);
        } while (condition());

        stop(Seconds(0.1));
    }
}