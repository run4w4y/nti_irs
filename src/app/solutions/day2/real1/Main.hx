package app.solutions.day2.real1;

import trik.Brick;
import app.solutions.day2.real1.Model;
import robotModel.Environment;
import robotModel.motorManager.MotorManager;
import robotModel.motorManager.RealManager;


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
        var model = new Model(manager, {
            frontSensor: Brick.sensor("D1"),
            backSensor: Brick.sensor("D2"),
            leftSensor: Brick.sensor("A1"),
            rightSensor: Brick.sensor("A2"),
            environment: env,
            cellSize: 400
        });
        model.solution();
    }
}