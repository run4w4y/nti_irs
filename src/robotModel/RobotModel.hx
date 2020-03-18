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
import graph.Direction;
import graph.Node;
import graph.Labyrinth;

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
    var executor    :MovementExecutor;

    @:updateFrequency(10)
    inline function readSensor(sensor:Sensor):Int {
        return sensor.read();
    }

    function checkSensor(sensor:Sensor):Bool {
        return switch (environment) {
            case Simulator: readSensor(sensor) <= 70;
            case Real:      readSensor(sensor) <= 25;
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
        var actions = [Go, TurnRight, Go, TurnLeft, Go, TurnRight, Go, TurnLeft, Go, Go, TurnLeft, Go, Go, TurnLeft, Go, TurnRight, Go, TurnLeft, Go, Go, Go, TurnLeft, Go];

        for (action in actions)
            executor.add(action);
        executor.execute();

        Brick.display.clear();
        Brick.display.addLabel('finish', new image.Pixel(0, 0));
        Brick.display.redraw();
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

        if (environment == Simulator)
            manager.goEncoders(150);
        
        executor = 
            if (environment == Simulator)
                new MovementExecutor(manager, 1370)
            else
                new MovementExecutor(manager, 619);
    }
}