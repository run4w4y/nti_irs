package app.main;

import trik.Brick;
import trik.Script;
import robotModel.RobotModel;
import robotModel.Environment;
import robotModel.motorManager.MotorManager;
import robotModel.motorManager.RealManager;
import artag.Artag;
import app.artagDecoder.ArtagDecoder;

import connectionPool.PoolMember;
import connectionPool.ConnectionPool;
import connectionPool.action.PoolAction;
import connectionPool.request.RequestHandler;
import graph.Labyrinth;
import graph.LabyrinthPoolActions;

class PoolConfig {
    public static var helloHandler = new HelloWorldHandler();
    public static var master       = new PoolMember(10, '192.168.77.1');
    public static var slave        = new PoolMember(20);
}


class HelloWorldHandler extends RequestHandler {
    override public function call(_:Dynamic):Dynamic {
        return "World";
    }
}


class HelloWorldAction extends PoolAction {
    override function executeInner() {
        var res = request({handler: PoolConfig.helloHandler}, PoolConfig.slave);
        Brick.display.clear();
        Brick.display.addLabel('Hello, $res!', new image.Pixel(10, 10));
        Brick.display.redraw();
        Script.wait(Seconds(5));
    }
}


class Main {
    public static function main():Void {
        var pool = new ConnectionPool(PoolConfig.master, [PoolConfig.slave], [PoolConfig.helloHandler]);
        pool.addActions([
            new HelloWorldAction(PoolConfig.master),
        ]);
        pool.execute();
    }
}