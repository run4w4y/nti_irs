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
        // var env = Real;
        // var manager:MotorManager = new RealManager(
        //     Brick.motor("M4"),
        //     Brick.motor("M3"),
        //     Brick.encoder("E4"),
        //     Brick.encoder("E3"),
        //     54,
        //     true
        // );
        // var model = new RobotModel(manager, {
        //     frontSensor: Brick.sensor("D1"),
        //     backSensor: Brick.sensor("D2"),
        //     leftSensor: Brick.sensor("A1"),
        //     rightSensor: Brick.sensor("A2"),
        //     environment: env,
        //     cellSize: 400
        // });
        // model.solution();

        // var pic = Brick.getPhoto();
        // var picString = haxe.Json.stringify(pic.map(function (a) return a.map(function (b) return [b.r, b.g, b.b])));
        // // Script.system("rm pic.json");
        // // Script.wait(Seconds(1));
        // Script.writeToFile("pic.json", picString);
        // var artag = new Artag(pic);
        // var decoder = new ArtagDecoder(artag);
        // Script.print(decoder.read());

        var pool = new ConnectionPool(PoolConfig.master, [PoolConfig.slave], [PoolConfig.helloHandler]);
        pool.addActions([
            new HelloWorldAction(PoolConfig.master),
        ]);
        pool.execute();
    }
}