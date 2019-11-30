package trik.robotModel;

import trik.Trik.*;
import trik.time.Time;
import trik.robot.motor.Motor;
import trik.robot.sensor.Sensor;
import trik.robot.encoder.Encoder;
import trik.robotModel.Environment;
import trik.robotModel.ModelArguments;
import Math.*;

using Lambda;


class RobotModel {
    public var leftMotor    :Motor;
    public var rightMotor   :Motor;
    public var leftEncoder  :Encoder;
    public var rightEncoder :Encoder;
    public var cameraPort   :String;
    public var environment  :Environment;
    public var rotateCount = 0;

    @:generic
    function nullcoalescence<T>(value:Null<T>, defaultValue:T):T {
        return if (value == null) defaultValue else value;
    }

    function sign(value:Float) {
        if (value > 0) return 1;
        else if (value < 0) return -1;
        else return 0;
    } 

    public function stop(?delayTime:Time):Void {
        delayTime = nullcoalescence(delayTime, Milliseconds(0));
        this.leftMotor.setPower(0);
        this.rightMotor.setPower(0);
        script.wait(delayTime);
    }

    public function resetEncoders():Void {
        leftEncoder.reset();
        rightEncoder.reset();
    }

    public function calibrateGyro(?duration:Time) {
        duration = nullcoalescence(duration, Seconds(10));
        brick.gyroscope.calibrate(duration);
    }

    public function readGyro():Float {
        return brick.gyroscope.read()[6]/1000;
    }

    public function readGyro360():Float {
        return (360 - readGyro()) % 360;
    }

    public function moveP(speed:Int=100, ?condition:(Void -> Bool)):Void {
        resetEncoders();
        var direction = ((rotateCount + 2) % 4) - 2;
        do {
            var gyroValue = readGyro();
            var error = 
                if (direction == -2)
                    gyroValue + sign(gyroValue) * direction * 90;
                else
                    gyroValue - direction * 90;

            leftMotor.setPower(round(speed - error * 38));
            rightMotor.setPower(round(speed + error * 38));

            if (condition == null) return;
            script.wait(Milliseconds(1));
        } while (condition());
        stop(Seconds(0.1));
    }

    function turnSimulator(angle, speed):Void {
        var deg = 250;
        if (angle == 90) {
            leftMotor.setPower(speed);
            rightMotor.setPower(-speed);

            while (leftEncoder.read() < deg) script.wait(Milliseconds(1));
            rotateCount += 1;
        } else {
            leftMotor.setPower(-speed);
            rightMotor.setPower(speed);
            while (rightEncoder.read() < deg) script.wait(Milliseconds(1));
            rotateCount -= 1;
        }
        stop(Seconds(0.1));
    }

    public function turn(angle, ?speed:Int=50):Void {
        resetEncoders();

        switch (environment) {
            case Simulator:
                turnSimulator(angle, speed);
            case _:
                return;
        }
    }

    public function new(args:ModelArguments):Void {
        this.leftMotor    = args.leftMotor;
        this.rightMotor   = args.rightMotor;
        this.leftEncoder  = args.leftEncoder;
        this.rightEncoder = args.rightEncoder;
        this.cameraPort   = nullcoalescence(args.cameraPort, "video1");
        this.environment  = args.environment;
    }
}