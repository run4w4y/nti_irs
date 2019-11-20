package trik.robot.motor;

extern class Motor {
    public function brake    (duration:Int) :Void;
    public function power    ()             :Int;
    public function powerOff ()             :Void;
    public function setPower (power:Int)    :Void;
}