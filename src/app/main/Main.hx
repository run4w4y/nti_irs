package app.main;

import trik.Brick;
import robotModel.RobotModel;
import robotModel.motor.Motor;
import robotModel.motor.Encoder;
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
        var motorManager = new MotorManager({
            leftMotor: new Motor("M4", new Encoder("E4"), true),
            rightMotor: new Motor("M3", new Encoder("E3"), true),
            wheelRadius: 54,
            sensorManager: sensorManager
        });
        var model = new RobotModel(589, motorManager, sensorManager);
        model.solution();
    }
}