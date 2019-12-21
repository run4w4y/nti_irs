package app.main;

import trik.Trik.*;
import app.model.FinalModel;
import robotModel.Environment;


class Main {
    public static function main():Void {
        var model = new FinalModel({
            leftMotor:    brick.motor("M4"),
            rightMotor:   brick.motor("M3"),
            leftEncoder:  brick.encoder("E4"),
            rightEncoder: brick.encoder("E3"), 
            frontSensor:  brick.sensor("A1"),
            leftSensor:   brick.sensor("A3"),
            rightSensor:  brick.sensor("A2"),
            environment:  Simulator
        });
        model.solution();
    }
}