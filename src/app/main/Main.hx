package app.main;

import trik.Brick;
import trik.Script;
import robotModel.RobotModel;
import robotModel.Environment;
import robotModel.motorManager.MotorManager;
import robotModel.motorManager.RealManager;
import robotModel.motorManager.SimulatorManager;
import artag.Artag;
import app.artagDecoder.ArtagDecoder;


class Main {
    public static function main():Void {
        var env = Simulator;
        var manager:MotorManager = new SimulatorManager(
            Brick.motor("M4"),
            Brick.motor("M3"),
            Brick.encoder("E4"),
            Brick.encoder("E3"),
            54
        );
        var model = new RobotModel(manager, {
            frontSensor: Brick.sensor("D1"),
            backSensor: Brick.sensor("D2"),
            leftSensor: Brick.sensor("A2"),
            rightSensor: Brick.sensor("A1"),
            environment: env,
            cellSize: 400
        });
        model.solution();
    }
}