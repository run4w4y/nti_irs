package robotModel.sensorManager;

import robotModel.sensor.GenericSensor;
import robotModel.sensorManager.ManagerArgs;

using tools.NullTools;


class BaseManager {
    public var frontSensor:Null<GenericSensor<Int>>;
    public var rightSensor:Null<GenericSensor<Int>>;
    public var backSensor:Null<GenericSensor<Int>>;
    public var leftSensor:Null<GenericSensor<Int>>;
    var defaultLength:Int;

    public function new(args:ManagerArgs, defaultLength) {
        frontSensor = args.frontSensor;
        leftSensor = args.frontSensor;
        backSensor = args.backSensor;
        rightSensor = args.rightSensor;
        this.defaultLength = defaultLength;
    }

    public inline function checkFront(?length:Int):Bool {
        return frontSensor.read() <= length.coalesce(defaultLength);
    }

    public inline function checkLeft(?length:Int):Bool {
        return leftSensor.read() <= length.coalesce(defaultLength);
    }

    public inline function checkBack(?length:Int):Bool {
        return backSensor.read() <= length.coalesce(defaultLength);
    }
    public inline function checkRight(?length:Int):Bool {
        return rightSensor.read() <= length.coalesce(defaultLength);
    }
}