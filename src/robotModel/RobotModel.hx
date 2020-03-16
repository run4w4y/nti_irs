package robotModel;

import time.Time;
import trik.Script;
import trik.Brick;
import trik.robot.sensor.Sensor;
import robotModel.Environment;
import robotModel.ModelArguments;
import robotModel.motorManager.MotorManager;

using tools.NullTools;


class RobotModel {
    var cameraPort  :String;
    var environment :Environment;
    var frontSensor :Sensor;
    var leftSensor  :Sensor;
    var rightSensor :Sensor;
    var backSensor  :Sensor;
    var cellSize    :Float;
    var manager     :MotorManager;

    function checkSensor(sensor:Sensor) {
        return switch (environment) {
            case Simulator: sensor.read() <= 70;
            case Real:      sensor.read() <= 15;
        }
    }

    inline function checkLeft():Bool {
        return checkSensor(leftSensor);
    }

    inline function checkRight():Bool {
        return checkSensor(rightSensor);
    }

    inline function checkFront():Bool {
        return checkSensor(frontSensor);
    }

    inline function checkBack():Bool {
        return checkSensor(backSensor);
    }

    function restoreCalibration():Void {
        if (environment == Simulator)
            return;

        Brick.gyroscope.setCalibrationValues(Brick.gyroscope.getCalibrationValues());
    }

    public function solution():Void {
        manager.goEncoders(2000);
    }

    public function new(manager:MotorManager, args:ModelArguments):Void {
        restoreCalibration();
        this.manager = manager;
        Script.wait(Seconds(0.05));
        manager.currentDirection = Brick.gyroscope.read();
        cameraPort  = args.cameraPort.coalesce("video2");
        environment = args.environment;
        frontSensor = args.frontSensor;
        leftSensor  = args.leftSensor;
        rightSensor = args.rightSensor;
        backSensor  = args.backSensor;
        cellSize    = args.cellSize;
    }
}