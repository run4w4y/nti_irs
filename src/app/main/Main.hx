package src.app.main;

import src.trik.Trik.*;
import src.app.model.FinalModel;
import src.robotModel.Environment;


class Main {
    public static function main():Void {
        var model = new FinalModel({
            leftMotor:    brick.motor("M4"),
            rightMotor:   brick.motor("M3"),
            leftEncoder:  brick.encoder("E4"),
            rightEncoder: brick.encoder("E3"), 
            frontSensor:  brick.sensor("D1"),
            leftSensor:   brick.sensor("D2"),
            environment:  Simulator
        });
        model.solution();
    }
}