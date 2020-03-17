package robotModel.speedManager;

import robotModel.speedManager.SpeedManager;
import Math.*;
import exceptions.ValueException;


class SineAcceleration implements SpeedManager {
    var accelF:Null<Float -> Float>;
    var decelF:Null<Float -> Float>;
    var accelPoint:Null<Int>;
    var decelPoint:Null<Int>;
    var maxSpeed:Int;
    var minSpeed:Int;

    public function new(minSpeed:Int, maxSpeed:Int, ?accelPoint:Int, ?decelPoint:Int, ?path:Int) {
        this.minSpeed = minSpeed;
        this.maxSpeed = maxSpeed;
        this.accelPoint = accelPoint;
        this.decelPoint = path - decelPoint;

        if (decelPoint - accelPoint < 0)
            throw new ValueException('accelPoint and decelPoint cant overlap with each other');
        if (decelPoint > path)
            throw new ValueException('decelPoint must not be bigger than path');
        if (decelPoint != null && path == null)
            throw new ValueException('path must not be null if decelPoint was defined');

        accelF = 
            if (accelPoint != null) 
                function (x:Float) 
                    return sin(x * PI / 2 / accelPoint)
            else
                null;
        decelF = 
            if (decelPoint != null)
                function (x:Float)
                    return sin(path - x) * (PI / 2 / this.decelPoint)
            else
                null;
    }

    public function calculate(x:Float):Float {
        var k = if (accelPoint != null && x < accelPoint) accelF(x)
            else if (decelPoint != null && x > decelPoint) decelF(x)
            else 1;
        var delta = (maxSpeed - minSpeed) * k;
        return minSpeed + delta;
    }
}