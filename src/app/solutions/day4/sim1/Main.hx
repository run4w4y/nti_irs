package app.solutions.day4.sim1;

import app.solutions.day4.sim1.Model;
import robotModel.motor.Motor;
import robotModel.motor.Encoder;
import robotModel.sensor.IRSensor;
import robotModel.sensor.USSensor;


class Main {
    public static function main():Void {
        var sensorManager = new robotModel.sensorManager.SimulatorManager({
            leftSensor: new IRSensor("A2"),
            rightSensor: new IRSensor("A1"),
            frontSensor: new USSensor("D1"),
            backSensor: new USSensor("D2")
        });
        var motorManager = new robotModel.motorManager.SimulatorManager({
            leftMotor: new Motor("M4", new Encoder("E4")),
            rightMotor: new Motor("M3", new Encoder("E3")),
            wheelRadius: 54,
            sensorManager: sensorManager
        });
        var model = new Model(1370, motorManager, sensorManager);
        model.solution();
    }
}

