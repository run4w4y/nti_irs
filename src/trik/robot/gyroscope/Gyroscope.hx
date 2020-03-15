package trik.robot.gyroscope;

extern class Gyroscope {
    public function calibrate            (duration:Int)   :Void;
    public function getCalibrationValues ()               :Dynamic;
    public function isCalibrated         ()               :Bool;
    public function read                 ()               :Array<Int>;
    public function readRawData          ()               :Array<Int>;
    public function setCalibrationValues (values:Dynamic) :Void;
}