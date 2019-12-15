package src.trik.robot.objectSensor;

extern class ObjectSensor {
    public function detect ()                        :Void;
    public function init   (displayCameraInput:Bool) :Void;
    public function read   ()                        :Array<Int>;
    public function stop   ()                        :Void;
}