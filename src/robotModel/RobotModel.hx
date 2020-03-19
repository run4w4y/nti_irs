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
import connectionPool.ConnectionPool;
import connectionPool.PoolMember;
import connectionPool.action.PoolAction;
import connectionPool.request.RequestHandler;
import graph.Labyrinth;
import graph.Direction;
import graph.Node;
using tools.NullTools;
using StringTools;


enum WatcherRes {
    NotFound;
    FoundLeft;
    FoundRight;
    FoundFront;
    FoundBack;
}

class Watcher extends RequestHandler {
    var prevLeft:Int;
    var prevRight:Int;
    var prevFront:Int;
    var prevBack:Int;
    var left:Void -> Int;
    var right:Void -> Int;
    var front:Void -> Int;
    var back:Void -> Int;

    public function new(left:Void -> Int, right:Void -> Int, front:Void -> Int, back:Void -> Int):Void {
        super();
        this.left = left;
        this.right = right;
        this.front = front;
        this.back = back;
        prevLeft = left();
        prevRight = right();
        prevFront = front();
        prevBack = back();
    }

    override public function call(_:Dynamic):Dynamic {
        var res = NotFound;
        if (Math.abs(left() - prevLeft) <= 2)
            res = FoundLeft;
        if (Math.abs(right() - prevRight) <= 2)
            res = FoundRight;
        if (Math.abs(front() - prevFront) <= 2)
            res = FoundFront;
        if (Math.abs(back() - prevBack) <= 2)
            res = FoundBack;
        // prevBack = back();
        // prevLeft = left();
        // prevRight = right();
        // prevFront = front();
        return res;
    }
}

// class Localization extends PoolAction {
//     var g:Labyrinth;
//     var startDir:Direction;
//     var executor:MovementExecutor;

//     public function new(agent:PoolMember, startDir:Direction, executor:MovementExecutor):Void {
//         super(agent);
//         g = new Labyrinth(8, 8);
//         this.startDir = startDir;
//         this.executor = executor;
//     }

//     override function executeInner():Void {

//     }
// }

class TestRide extends PoolAction {
    var executor:MovementExecutor;
    var checkBack: Void -> Bool;
    var checkFront: Void -> Bool;
    var checkLeft: Void -> Bool;
    var checkRight: Void -> Bool;

    public function new(agent:PoolMember, executor:MovementExecutor,
        checkLeft:Void -> Bool, checkRight:Void -> Bool, checkFront:Void -> Bool,
        checkBack: Void -> Bool
    ) {
        super(agent);
        this.executor = executor;
        this.checkBack = checkBack;
        this.checkLeft = checkLeft;
        this.checkRight = checkRight;
        this.checkFront = checkFront;
    }

    override function executeInner():Void {
        var actions = [Go, Go, Go, Go, Go, TurnRight, Go, TurnLeft, Go, Go, TurnRight, Go, Go, Go];
        for (action in actions) {
            executor.add(action);
            executor.execute();

            var change = request({
                handler: PoolConfig.watcher
            }, PoolConfig.slave);

            Script.print(change);
        }
    }
}

class PoolConfig {
    public static var master = new PoolMember(10, '192.168.77.1');
    public static var slave = new PoolMember(20);
    public static var watcher:Watcher;
}


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

    inline function readRight():Int {
        return readSensor(rightSensor);
    }

    inline function readLeft():Int {
        return readSensor(leftSensor);
    }

    inline function readFront():Int {
        return readSensor(frontSensor);
    }

    inline function readBack():Int {
        return readSensor(backSensor);
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
        var pool = new ConnectionPool(PoolConfig.master, [PoolConfig.slave], [
            PoolConfig.watcher
        ]);
        pool.addActions([
            new TestRide(
                PoolConfig.master,
                executor,
                checkLeft, checkRight, checkFront, checkBack
            )
        ]);
        pool.execute();
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
        this.manager.frontSensor = frontSensor;

        PoolConfig.watcher = new Watcher(
            readLeft, readRight, readFront, readBack
        );

        if (environment == Simulator)
            manager.goEncoders(150);
        
        executor = 
            if (environment == Simulator)
                new MovementExecutor(manager, 1370)
            else
                new MovementExecutor(manager, 595);
    }
}