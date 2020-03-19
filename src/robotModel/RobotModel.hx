package robotModel;

import time.Time;
import trik.Script;
import trik.Brick;
import robotModel.motorManager.MotorManager;
import robotModel.sensorManager.SensorManager;
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
    var sensorManager:SensorManager;

    public function new(sensorManager:SensorManager):Void {
        super();
        prevLeft = sensorManager.leftSensor.read();
        prevRight = sensorManager.rightSensor.read();
        prevFront = sensorManager.frontSensor.read();
        prevBack = sensorManager.backSensor.read();
    }

    override public function call(_:Dynamic):Dynamic {
        var res = NotFound;
        if (Math.abs(sensorManager.leftSensor.read() - prevLeft) <= 2)
            res = FoundLeft;
        if (Math.abs(sensorManager.rightSensor.read() - prevRight) <= 2)
            res = FoundRight;
        if (Math.abs(sensorManager.frontSensor.read() - prevFront) <= 2)
            res = FoundFront;
        if (Math.abs(sensorManager.backSensor.read() - prevBack) <= 2)
            res = FoundBack;
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

    public function new(agent:PoolMember, executor:MovementExecutor) {
        super(agent);
        this.executor = executor;
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
    var motorManager  :MotorManager;
    var executor      :MovementExecutor;
    var sensorManager :SensorManager;

    function restoreCalibration():Void {
        Brick.gyroscope.setCalibrationValues(Brick.gyroscope.getCalibrationValues());
    }

    public function solution():Void {
        var pool = new ConnectionPool(PoolConfig.master, [PoolConfig.slave], [
            PoolConfig.watcher
        ]);
        pool.addActions([
            new TestRide(
                PoolConfig.master,
                executor
            )
        ]);
        pool.execute();
    }

    public function new(cellSize:Int, motorManager:MotorManager, sensorManager:SensorManager):Void {
        restoreCalibration();
        this.motorManager = motorManager;
        this.sensorManager = sensorManager;

        PoolConfig.watcher = new Watcher(sensorManager);
        
        executor = new MovementExecutor(motorManager, cellSize);
    }
}