package app.solutions.day3.sim1;

import trik.Brick;
import app.solutions.day3.sim1.Model;
import robotModel.motorManager.SimulatorManager as MotorManager;
import robotModel.sensor.IRSensor;
import robotModel.sensor.USSensor;
import robotModel.sensorManager.SimulatorManager as SensorManager;


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
            sensorManager
        );
        var model = new Model(589, motorManager, sensorManager);
        model.solution();
    }
}