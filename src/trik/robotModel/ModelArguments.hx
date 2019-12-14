package trik.robotModel;

import trik.robot.motor.Motor;
import trik.robot.encoder.Encoder;
import trik.robot.sensor.Sensor;
import trik.robotModel.Environment;


typedef ModelArguments = {
    leftMotor:Motor,
    rightMotor:Motor,
    leftEncoder:Encoder,
    rightEncoder:Encoder,
    environment:Environment,
    ?cameraPort:String,
    
}