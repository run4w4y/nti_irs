package;

import trik.robotModel.RobotModel;
import trik.robotModel.ModelArguments;
import trik.robot.sensor.Sensor;
import trik.time.Time;
import trik.robot.display.Pixel;
import Math.*;
import trik.Trik.*;


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

    public function solution():Void {
        var leftStart = leftSensor.read();
        var leftMax = leftStart;

        moveP(90, function() {
            var readVal = leftSensor.read();

            if (abs(readVal - leftStart) > 10 && readVal >= leftMax) 
                leftMax = readVal;

            return frontSensor.read() > 25;
        });

        stop(Seconds(0.5));
        
        moveP(-90, function() {
            return leftMax > leftSensor.read();
        });

        stop(Seconds(0.5));

        turn(-90, 25);

        stop(Seconds(0.5));

        moveP(90, function() {
            return frontSensor.read() > (leftMax - leftStart) / 2;
        });

        brick.display.addLabel("finish", new Pixel(0, 0));
    }
}