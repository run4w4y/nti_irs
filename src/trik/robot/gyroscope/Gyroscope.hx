package trik.robot.gyroscope;

extern class Gyroscope {
    public function calibrate            (duration:Int)      :Void;
    public function getCalibrationValues ()                  :Array<Int>; // im not sure what the fuck is this tbh
    public function isCalibrated         ()                  :Bool;
    public function read                 ()                  :Array<Int>;
    public function readRawData          ()                  :Array<Int>;
    public function setCalibrationValues (values:Array<Int>) :Void;
}