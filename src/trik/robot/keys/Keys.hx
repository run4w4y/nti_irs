package src.trik.robot.keys;

extern class Keys {
    public function isPressed  (key:Int) :Bool;
    public function reset      ()        :Void;
    public function wasPressed (key:Int) :Bool;
}