package trik.robot.lineSensor;

extern class LineSensor {
    public function detect ()                        :Void;
    public function init   (displayCameraInput:Bool) :Void;
    public function read   ()                        :Array<Int>;
    public function stop   ()                        :Void;
}