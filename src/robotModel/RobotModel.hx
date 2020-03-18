package robotModel;

import time.Time;
import trik.Script;
import trik.Brick;
import trik.robot.sensor.Sensor;
import robotModel.Environment;
import robotModel.ModelArguments;
import robotModel.motorManager.MotorManager;
import movementExecutor.MovementExecutor;
import movementExecutor.Movement;

using tools.NullTools;
using StringTools;


class RobotModel {
    var cameraPort  :String;
    var environment :Environment;
    var frontSensor :Sensor;
    var leftSensor  :Sensor;
    var rightSensor :Sensor;
    var backSensor  :Sensor;
    var cellSize    :Float;
    var manager     :MotorManager;

    function checkSensor(sensor:Sensor):Bool {
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
        if (environment == Simulator)
            manager.goEncoders(150);
        var executor = 
            if (environment == Simulator)
                new MovementExecutor(manager, 1370)
            else
                new MovementExecutor(manager, 580);

        var line = Script.readAll("input.txt")[0].trim();
        var actions = [for (i in line.split(' ')) switch (Std.parseInt(i)) {
            case 0:
                Undefined;
            case 1:
                TurnLeft;
            case 2: 
                TurnRight;
            case _:
                Go; 
        }].filter(function (x) return x != Undefined);
        Script.print(actions);
        // var actions = [TurnAround, Go, Go];

        for (action in actions)
            executor.add(action);
        executor.execute();

        Brick.display.addLabel('finish', new image.Pixel(0, 0));
    }

    public function new(manager:MotorManager, args:ModelArguments):Void {
        restoreCalibration();
        this.manager = manager;
        Script.wait(Seconds(0.05));
        this.manager.currentDirection = Brick.gyroscope.read();
        cameraPort  = args.cameraPort.coalesce("video2");
        environment = args.environment;
        frontSensor = args.frontSensor;
        leftSensor  = args.leftSensor;
        rightSensor = args.rightSensor;
        backSensor  = args.backSensor;
        cellSize    = args.cellSize;
        this.manager.leftSensor = leftSensor;
        this.manager.rightSensor = rightSensor;
    }
}