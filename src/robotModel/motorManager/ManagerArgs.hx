package robotModel.motorManager;

import robotModel.motor.Motor;
import robotModel.sensorManager.SensorManager;


typedef ManagerArgs = {
    leftMotor: Motor,
    rightMotor: Motor,
    wheelRadius: Float,
    sensorManager: SensorManager
}