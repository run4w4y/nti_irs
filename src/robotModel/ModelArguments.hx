package robotModel;

import trik.robot.motor.Motor;
import trik.robot.encoder.Encoder;
import trik.robot.sensor.Sensor;
import robotModel.Environment;


typedef ModelArguments = {
    cellSize:Float,
    environment:Environment,
    ?cameraPort:String,
    ?frontSensor:Sensor,
    ?leftSensor:Sensor,
    ?rightSensor:Sensor,
    ?backSensor:Sensor,
}