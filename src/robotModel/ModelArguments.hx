package robotModel;

import trik.robot.motor.Motor;
import trik.robot.encoder.Encoder;
import trik.robot.sensor.Sensor;
import robotModel.Environment;


typedef ModelArguments = {
    frontSensor:Sensor,
    leftSensor:Sensor,
    rightSensor:Sensor,
    backSensor:Sensor,
    cellSize:Float,
    environment:Environment,
    ?cameraPort:String
}