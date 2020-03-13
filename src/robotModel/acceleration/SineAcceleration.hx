package robotModel.acceleration;

import Math.*;
import exceptions.ValueException;


class SineAcceleration {
    var accelF:Null<Float -> Float>;
    var decelF:Null<Float -> Float>;
    var accelPoint:Null<Int>;
    var decelPoint:Null<Int>;
    var maxSpeed:Int;
    var minSpeed:Int;

    public function new(minSpeed:Int, maxSpeed:Int, ?accelPoint:Int=0, ?decelPoint:Int=0, ?path:Int) {
        if (decelPoint - accelPoint < 0)
            throw new ValueException('accelPoint and decelPoint cant overlap with each other');
        
        this.accelPoint = accelPoint;
        this.decelPoint = decelPoint;

        accelF = 
            if (accelPoint != null) 
                function (x:Float) 
                    return sin(x * (PI / 2 / accelPoint))
            else
                null;
        decelF = 
            if (decelPoint != null)
                function (x:Float) {
                    if (path == null)
                        throw new ValueException('path must not be null if decelPoint was defined');
                    return sin((path - x) * (PI / 2 / decelPoint));
                }
            else
                null;
    }

    public function calculate(x:Float):Float {
        var k = if (accelPoint != null && x < accelPoint) accelF(x)
            else if (decelPoint != null && x > decelPoint) decelF(x)
            else 1;
        return minSpeed + (maxSpeed - minSpeed) * k;
    }
}