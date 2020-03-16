package app.main;

import trik.Brick;
import trik.Script;
import robotModel.RobotModel;
import robotModel.Environment;
import robotModel.motorManager.MotorManager;
import robotModel.motorManager.RealManager;

import connectionPool.PoolMember;
import connectionPool.ConnectionPool;
import connectionPool.action.PoolAction;


class HelloWorldAction extends PoolAction {
    override function executeInner() {
        Brick.led.orange();
        Brick.motor("M4").setPower(100);
        Script.wait(Seconds(1));
    }
}


class Main {
    public static function main():Void {
        var env = Real;
        var manager:MotorManager = new RealManager(
            Brick.motor("M4"),
            Brick.motor("M3"),
            Brick.encoder("E4"),
            Brick.encoder("E3"),
            54,
            true
        );
        var model = new RobotModel(manager, {
            frontSensor: Brick.sensor("D1"),
            backSensor: Brick.sensor("D2"),
            leftSensor: Brick.sensor("A1"),
            rightSensor: Brick.sensor("A2"),
            environment: env,
            cellSize: 400
        });
        model.solution();

        // var master = new PoolMember(10, '192.168.77.1');
        // var slave = new PoolMember(20);
        // var pool = new ConnectionPool(master, [slave]);
        // pool.addActions([
        //     new HelloWorldAction(slave),
        //     new HelloWorldAction(master)
        // ]);
        // pool.execute();
    }
}