package app.solutions.day1.real1;

import trik.Brick;
import app.solutions.day1.real1.Model;
import robotModel.motorManager.RealManager as MotorManager;
import robotModel.sensor.IRSensor;
import robotModel.sensor.USSensor;
import robotModel.sensorManager.RealManager as SensorManager;


class Main {
    public static function main():Void {
        var sensorManager = new SensorManager({
            leftSensor: new IRSensor("A1"),
            rightSensor: new IRSensor("A2"),
            frontSensor: new USSensor("D1"),
            backSensor: new USSensor("D2")
        });
        var motorManager = new MotorManager(
            Brick.motor("M4"),
            Brick.motor("M3"),
            Brick.encoder("E4"),
            Brick.encoder("E3"),
            54,
            sensorManager,
            true
        );
        var model = new Model(589, motorManager, sensorManager);
        model.solution();
    }
}