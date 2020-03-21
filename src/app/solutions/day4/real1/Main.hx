package app.solutions.day4.real1;

import app.solutions.day4.real1.Model;
import robotModel.motor.Motor;
import robotModel.motor.Encoder;
import robotModel.sensor.IRSensor;
import robotModel.sensor.USSensor;


class Main {
    public static function main() {
        var sensorManager = new robotModel.sensorManager.RealManager({
            leftSensor: new IRSensor("A1"),
            rightSensor: new IRSensor("A2"),
            frontSensor: new USSensor("D1"),
            backSensor: new USSensor("D2")
        });
        var motorManager = new robotModel.motorManager.RealManager({
            leftMotor: new Motor("M4", new Encoder("E4"), true),
            rightMotor: new Motor("M3", new Encoder("E3"), true),
            wheelRadius: 54,
            sensorManager: sensorManager
        });
        var model = new Model(589, motorManager, sensorManager);
        model.solution();
    }
}