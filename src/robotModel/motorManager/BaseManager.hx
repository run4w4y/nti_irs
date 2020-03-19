package robotModel.motorManager;

import angle.Angle;
import time.Time;
import trik.Brick;
import trik.Script;
import trik.robot.motor.Motor;
import trik.robot.encoder.Encoder;
import robotModel.speedManager.SpeedManager;
import robotModel.speedManager.pid.PID;
import robotModel.speedManager.pid.PIDCoefficients;
import robotModel.sensorManager.SensorManager;

using tools.NullTools;


class BaseManager {
    public var leftMotor:Motor;
    public var rightMotor:Motor;
    public var leftEncoder:Encoder;
    public var rightEncoder:Encoder;
    public var currentDirection:Angle;
    public var sensorManager:SensorManager;
    var wheelRadius:Float;
    var inversedVelocity:Bool;
    var inversedEncoders:Bool;

    public function new(leftMotor:Motor, rightMotor:Motor, leftEncoder:Encoder, rightEncoder:Encoder,
    wheelRadius:Float, sensorManager:SensorManager, ?inversedVelocity = false, ?inversedEncoders = false):Void {
        this.leftMotor = leftMotor;
        this.rightMotor = rightMotor;
        this.leftEncoder = leftEncoder;
        this.rightEncoder = rightEncoder;
        this.inversedVelocity = inversedVelocity;
        this.inversedEncoders = inversedEncoders;
        this.wheelRadius = wheelRadius;
        this.sensorManager = sensorManager;
        currentDirection = readGyro();
        resetEncoders();
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

    @:updateFrequency(7)
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
            
            startLeft(Math.round(speed - u));
            startRight(Math.round(speed + u));

            if (condition == null) return;
            Script.wait(interval);
        } while (condition());

        stop(Seconds(0.1));
    }
}