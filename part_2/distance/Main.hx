import src.trik.src.trik.*;
import src.trik.robotModel.Environment;

using Lambda;


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