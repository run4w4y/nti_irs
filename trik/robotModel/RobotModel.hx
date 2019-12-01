package trik.robotModel;

import trik.Trik.*;
import trik.time.Time;
import trik.robot.motor.Motor;
import trik.robot.sensor.Sensor;
import trik.robot.encoder.Encoder;
import trik.robotModel.Environment;
import trik.robotModel.ModelArguments;
import trik.pid.PID;
import trik.pid.PIDKoefficients;
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

    public function move(speed:Int=100, setpoint:Float, readF:(Void -> Float), 
    koefficients:PIDKoefficients, ?condition:(Void -> Bool), ?interval:Time):Void {
        interval = nullcoalescence(interval, Seconds(0.1));
        resetEncoders();

        var pid = new PID(interval, -100, 100, koefficients);
        
        do {
            var u = pid.calculate(readF(), setpoint);
            
            leftMotor.setPower(round(speed + u));
            rightMotor.setPower(round(speed - u));

            if (condition == null) return;
            script.wait(interval);
        } while (condition());

        stop(Seconds(0.1));
    }

    public function moveGyro(speed:Int=100, ?condition:(Void -> Bool), ?interval:Time):Void {
        var direction = ((rotateCount + 2) % 4) - 2;
        move(speed, 90 * direction, readGyro, {
            kp: 13,
            kd: 8,
            ki: 0.03
        }, condition, interval);
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