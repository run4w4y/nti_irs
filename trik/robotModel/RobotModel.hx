package trik.robotModel;

import trik.Trik.*;
import trik.time.Time;
import trik.robot.motor.Motor;
import trik.robot.sensor.Sensor;
import trik.robot.encoder.Encoder;
import trik.robotModel.Environment;
import trik.robotModel.ModelArguments;
import trik.pid.PID;
import trik.pid.PIDCoefficients;
import trik.angle.Angle;
import Math.*;

using Lambda;
using trik.tools.NullTools;


class RobotModel {
    public var leftMotor    :Motor;
    public var rightMotor   :Motor;
    public var leftEncoder  :Encoder;
    public var rightEncoder :Encoder;
    public var cameraPort   :String;
    public var environment  :Environment;
    public var rotateCount = 0;

    public function stop(?delayTime:Time):Void {
        delayTime = delayTime.coalesce(Milliseconds(0));
        this.leftMotor.setPower(0);
        this.rightMotor.setPower(0);
        script.wait(delayTime);
    }

    public function resetEncoders():Void {
        leftEncoder.reset();
        rightEncoder.reset();
    }

    public function calibrateGyro(?duration:Time) {
        duration = duration.coalesce(Seconds(10));
        brick.gyroscope.calibrate(duration);
    }

    public function readGyro():Angle {
        return new Angle(360 - brick.gyroscope.read()[6]/1000);
    }

    @:generic
    public function move<T>(speed:Int=100, setpoint:T, readF:(Void -> T), getError:(T -> T -> Float),
    koefficients:PIDCoefficients, ?condition:(Void -> Bool), ?interval:Time):Void {
        interval = interval.coalesce(Seconds(0.1));
        resetEncoders();

        var pid = new PID(interval, -100, 100, koefficients);
        
        do {
            var u = pid.calculate(getError(readF(), setpoint));
            
            leftMotor.setPower(round(speed + u));
            rightMotor.setPower(round(speed - u));

            if (condition == null) return;
            script.wait(interval);
        } while (condition());

        stop(Seconds(0.1));
    }

    public function moveGyro(speed:Int=100, ?condition:(Void -> Bool), ?interval:Time):Void {
        var direction = ((rotateCount + 2) % 4) - 2;
        move(speed, new Angle(90 * (4 - direction)), readGyro, function(value, setpoint) {
            return value.getDelta(setpoint);
        }, {
            kp: 12.5,
            kd: 7.5,
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
        this.cameraPort   = args.cameraPort.coalesce("video1");
        this.environment  = args.environment;
    }
}