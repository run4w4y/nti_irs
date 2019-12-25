package app.main;

import trik.Brick;
import app.model.FinalModel;
import robotModel.Environment;


class Main {
    public static function main():Void {
        var model = new FinalModel({
            leftMotor:    Brick.motor("M4"),
            rightMotor:   Brick.motor("M3"),
            leftEncoder:  Brick.encoder("E4"),
            rightEncoder: Brick.encoder("E3"), 
            frontSensor:  Brick.sensor("A1"),
            leftSensor:   Brick.sensor("A3"),
            rightSensor:  Brick.sensor("A2"),
            environment:  Simulator,
            wheelRadius:  5.6 / 2,
            cellSize:     700
        });
        model.solution();
    }
}