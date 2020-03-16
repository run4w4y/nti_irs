package robotModel.motorManager;

import angle.Angle;
import time.Time;
import trik.Brick;
import trik.Script;
import trik.robot.motor.Motor;
import trik.robot.encoder.Encoder;
import trik.robot.sensor.Sensor;
import robotModel.speedManager.SpeedManager;
import robotModel.speedManager.pid.PID;
import robotModel.speedManager.pid.PIDCoefficients;

using tools.NullTools;


class BaseManager {
    public var leftMotor:Motor;
    public var rightMotor:Motor;
    public var leftEncoder:Encoder;
    public var rightEncoder:Encoder;
    public var currentDirection:Angle;
    public var leftSensor:Null<Sensor> = null;
    public var rightSensor:Null<Sensor> = null;
    var wheelRadius:Float;
    var inversedVelocity:Bool;
    var inversedEncoders:Bool;

    public function new(leftMotor:Motor, rightMotor:Motor, leftEncoder:Encoder, rightEncoder:Encoder,
    wheelRadius:Float, ?inversedVelocity = false, ?inversedEncoders = false):Void {
        this.leftMotor = leftMotor;
        this.rightMotor = rightMotor;
        this.leftEncoder = leftEncoder;
        this.rightEncoder = rightEncoder;
        this.inversedVelocity = inversedVelocity;
        this.inversedEncoders = inversedEncoders;
        this.wheelRadius = wheelRadius;
        currentDirection = Brick.gyroscope.read();
    }

    inline function startMotor(motor:Motor, velocity:Int):Void {
        motor.setPower(if (inversedVelocity) -velocity else velocity);
    }

    inline function startLeft(velocity:Int):Void {
        startMotor(leftMotor, velocity);
    }

    inline function startRight(velocity:Int):Void {
        startMotor(rightMotor, velocity);
    }

    inline function readEncoder(encoder:Encoder):Int {
        var val = encoder.read();
        return if (inversedEncoders) -val else val;
    }

    inline function readLeft():Int {
        return readEncoder(leftEncoder);
    }

    inline function readRight():Int {
        return readEncoder(rightEncoder);
    }

    inline function resetEncoders():Void {
        leftEncoder.reset();
        rightEncoder.reset();
    }

    function move(speed:Int, controller:SpeedManager, getError:Void -> Float, 
    ?condition:Void -> Bool, ?interval:Time):Void {
        interval = interval.coalesce(Seconds(0.1));
        resetEncoders();
        
        do {
            var u = controller.calculate(getError());
            
            startLeft(Math.round(speed - u));
            startRight(Math.round(speed + u));

            if (condition == null) return;
            Script.wait(interval);
        } while (condition());

        stop(Seconds(0.1));
    }

    function moveGyro(speed:Int, ?condition:(Void -> Bool), ?interval:Time, ?coefficients:PIDCoefficients):Void {
        var defaults:PIDCoefficients = {
            kp: 1.05,
            kd: 0.4,
            ki: 0.0001
        };
        var pid = new PID(interval.coalesce(Seconds(.01)), -100, 100, coefficients.coalesce(defaults));
        move(speed, pid, function() {
                return Brick.gyroscope.read() - currentDirection;
            }, 
            condition, interval
        );
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
}