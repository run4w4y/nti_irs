package robotModel.motorManager;

import angle.Angle;
import trik.robot.motor.Motor;
import trik.robot.encoder.Encoder;
import trik.robot.sensor.Sensor;


interface MotorManager {
    public var leftMotor:Motor;
    public var rightMotor:Motor;
    public var leftEncoder:Encoder;
    public var rightEncoder:Encoder;
    public var currentDirection:Angle;

    public function turnLeft():Void;
    public function turnRight():Void;
    public function turnAround():Void;
    public function turn(angle:Float):Void;
    public function goEncoders(enc:Int, ?accelPoint:Int, ?decelPoint:Int):Void;
    public function goMillimeters(length:Int, ?acceleration:Bool):Void;
}