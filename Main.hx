import trik.robot.motor.Motor;
import trik.robotModel.RobotModel;
import trik.robot.display.Pixel;
import trik.time.Time;
import trik.Trik.*;
import Math.*;

using Lambda;


class Main {
    static var leftMotor    = brick.motor("M3");
    static var rightMotor   = brick.motor("M4");
    static var leftEncoder  = brick.encoder("E3");
    static var rightEncoder = brick.encoder("E4");

    static function stop() {
        leftMotor.setPower(0);
        rightMotor.setPower(0);
        script.wait(Seconds(2));
    }
    
    static function readGyro():Float {
        return brick.gyroscope.read()[6]/1000;
    }

    static function move(speed:Int = 100) {
        var error = readGyro();
        var up:Float = error * 10;

        leftMotor.setPower(round(speed + up));
        rightMotor.setPower(round(speed - up));

        script.wait(Milliseconds(10));
    }

    public static function main() {


        var frontSensor  = brick.sensor("D1");
        var leftSensor   = brick.sensor("D2");

        var leftStart = leftSensor.read();
        var leftMax = leftStart;
        var maxIndex = -1;
        var count = 0;
        var countLock = false;
        var readPrev = leftStart;
        
        while (frontSensor.read() > 25) {
            move(90);
            var readVal = leftSensor.read();

            if (!countLock && readPrev - readVal < -10) {
                ++count;
                countLock = true;
            }
            if (countLock && readPrev - readVal > 10)
                countLock = false;
            if (abs(readVal - leftStart) > 10 && readVal >= leftMax) 
                leftMax = readVal;
            
            readPrev = readVal;
        }

        stop();
        print(leftMax);

        while (leftMax > leftSensor.read())
            move(-90);

        stop();

        while (readGyro() > -75) {
            leftMotor.setPower(10);
            rightMotor.setPower(-10);
        }

        while (frontSensor.read() > 25) {
            leftMotor.setPower(100);
            rightMotor.setPower(100);
        }

        brick.display.addLabel("finish", new Pixel(0, 0));
    }
}