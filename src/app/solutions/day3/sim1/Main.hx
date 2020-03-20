package app.solutions.day3.sim1;

import app.solutions.day3.sim1.Model;
import robotModel.motor.Motor;
import robotModel.motor.Encoder;
import robotModel.motorManager.SimulatorManager as MotorManager;
import robotModel.sensor.IRSensor;
import robotModel.sensor.USSensor;
import robotModel.sensorManager.SimulatorManager as SensorManager;


class Main {
    public static function main():Void {
        var sensorManager = new SensorManager({
            leftSensor: new IRSensor("A2"),
            rightSensor: new IRSensor("A1"),
            frontSensor: new USSensor("D1"),
            backSensor: new USSensor("D2")
        });
        var motorManager = new MotorManager({
            leftMotor: new Motor("M4", new Encoder("E4")),
            rightMotor: new Motor("M3", new Encoder("E3")),
            wheelRadius: 54,
            sensorManager: sensorManager
        });
        var model = new Model(1370, motorManager, sensorManager);
        model.solution();
    }
}