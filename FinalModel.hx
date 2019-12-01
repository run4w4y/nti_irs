package;

import trik.robotModel.RobotModel;
import trik.robotModel.ModelArguments;
import trik.robot.sensor.Sensor;
import trik.time.Time;
import trik.robot.display.Pixel;
import Math.*;
import trik.Trik.*;
import trik.sequence.Sequence;


typedef FinalArguments = {
    > ModelArguments,
    frontSensor:Sensor,
    leftSensor:Sensor
}

class FinalModel extends RobotModel {
    var frontSensor:Sensor;
    var leftSensor:Sensor;

    public function new(args:FinalArguments):Void {
        super(args);
        this.frontSensor = args.frontSensor;
        this.leftSensor  = args.leftSensor;
    }

    public function moveWall(speed:Int=100, setpoint:Float, ?condition:(Void -> Bool), ?interval:Time):Void {
        move(speed, setpoint, function() {
            var readVal = leftSensor.read();
            return 
                if (abs(readVal - setpoint) > 3) 
                    setpoint
                else 
                    readVal;
        }, {kp: 0.5}, condition, interval);
    }

    public function solution():Void {
        var leftStart = leftSensor.read();
        var leftMax = leftStart;
        var maxIndex = -1;
        var count = 0;
        var countLock = false;
        var readPrev = leftStart;

        Sequence.sequence(stop(Seconds(.5)),
            moveWall(90, leftStart, function() {
                var readVal = leftSensor.read();

                if (!countLock && readPrev - readVal < -4) {
                    ++count;
                    countLock = true;
                }
                if (countLock && readPrev - readVal > 4)
                    countLock = false;
                
                if (abs(readVal - leftStart) > 10 && readVal > leftMax) {
                    leftMax = readVal;
                    maxIndex = count;
                    print("new min found " + leftMax + " " + maxIndex);
                }

                readPrev = readVal;
                return frontSensor.read() > 25;
            }),

            moveGyro(-90, function() {
                print(count);
                var readVal = leftSensor.read();

                if (!countLock && readPrev - readVal < -10) {
                    --count;
                    countLock = true;
                }
                if (countLock && readPrev - readVal > 10)
                    countLock = false;

                readPrev = readVal;
                return count != maxIndex - 1;
            }),

            turn(-90, 25),

            moveGyro(90, function() {
                return frontSensor.read() > (leftMax - leftStart) / 2;
            })
        );

        brick.display.addLabel("finish", new Pixel(0, 0));
    }
}