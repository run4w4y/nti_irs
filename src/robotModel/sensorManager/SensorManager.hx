package robotModel.sensorManager;

import robotModel.sensor.GenericSensor;


interface SensorManager {
    public var frontSensor:Null<GenericSensor<Int>>;
    public var rightSensor:Null<GenericSensor<Int>>;
    public var backSensor:Null<GenericSensor<Int>>;
    public var leftSensor:Null<GenericSensor<Int>>;

    public function checkFront(?length:Int):Bool;
    public function checkLeft(?length:Int):Bool;
    public function checkBack(?length:Int):Bool;
    public function checkRight(?length:Int):Bool;
}