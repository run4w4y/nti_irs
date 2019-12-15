package src.trik.robotModel;

import src.trik.robot.motor.Motor;
import src.trik.robot.encoder.Encoder;
import src.trik.robot.sensor.Sensor;
import src.trik.robotModel.Environment;


typedef ModelArguments = {
    leftMotor:Motor,
    rightMotor:Motor,
    leftEncoder:Encoder,
    rightEncoder:Encoder,
    environment:Environment,
    ?cameraPort:String,
    
}