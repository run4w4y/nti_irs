package robotModel.motorManager;

import trik.robot.motor.Motor;
import trik.robot.encoder.Encoder;


interface MotorManager {
    public var leftMotor:Motor;
    public var rightMotor:Motor;
    public var leftEncoder:Encoder;
    public var rightEncoder:Encoder;

    public function turnLeft():Void;
    public function turnRight():Void;
    public function turnAround():Void;
    public function turn(angle:Float):Void;
    public function goEncoders(enc:Int, ?acceleration:Bool):Void;
    public function goMillimeters(length:Int, ?acceleration:Bool):Void;
}