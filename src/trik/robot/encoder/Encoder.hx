package src.trik.robot.encoder;

extern class Encoder {
    public function read        () :Int;
    public function reset       () :Void;
    public function readRawData () :Int; 
}