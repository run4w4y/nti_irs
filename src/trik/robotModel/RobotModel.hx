package src.trik.robotModel;

import src.trik.Trik.*;
import src.trik.time.Time;
import src.trik.robot.motor.Motor;
import src.trik.robot.sensor.Sensor;
import src.trik.robot.encoder.Encoder;
import src.trik.robotModel.Environment;
import src.trik.robotModel.ModelArguments;
import src.trik.pid.PID;
import src.trik.pid.PIDCoefficients;
import src.trik.angle.Angle;
import Math.*;

using Lambda;
using src.trik.tools.NullTools;


class RobotModel {
    public var leftMotor    :Motor;
    public var rightMotor   :Motor;
    public var leftEncoder  :Encoder;
    public var rightEncoder :Encoder;
    public var cameraPort   :String;
    public var environment  :Environment;
    public var currentDirection = new Angle(0);

    function sign(n:Float):Int {
        return if (n < 0) -1
            else if (n > 0) 1
            else 1;
    }

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

    public function moveGyro(speed:Int=100, ?condition:(Void -> Bool), ?interval:Time, ?coefficients:PIDCoefficients):Void {
        var defaults:PIDCoefficients = {
            kp: 1.05,
            kd: 0.4,
            ki: 0.0001
        };
        move(speed, currentDirection, readGyro, function(value, setpoint) {
                return value.getDelta(setpoint);
            }, 
            if (coefficients == null) defaults else coefficients, 
            condition, interval
        );
    }

    function turnSimulator(angle:Float):Void {
        currentDirection = currentDirection.add(angle);
        moveGyro(0, function() {
                return abs(currentDirection.getDelta(readGyro())) > 1;
            }, Seconds(0.01), {kp: 1 }
        );
        stop(Seconds(0.1));
    }

    public function turn(angle:Float):Void {
        resetEncoders();

        switch (environment) {
            case Simulator:
                turnSimulator(angle);
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