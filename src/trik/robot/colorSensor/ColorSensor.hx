package trik.robot.colorSensor;

extern class ColorSensor {
    public function init (displayCameraInput:Bool) :Void;
    public function read (x:Int, y:Int)            :Array<Int>;
    public function stop ()                        :Void;
}