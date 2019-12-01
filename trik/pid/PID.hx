package trik.pid;

import trik.time.Time;
import Math.*;

using trik.tools.TimeTools;


class PID {
    var interval  :Time;
    var min       :Float;
    var max       :Float;
    var kp        :Float;
    var kd        :Float;
    var ki        :Float;
    var prevError :Float = 0;
    var integral  :Float = 0;

    public function new(interval:Time, min:Float, max:Float, kp:Float, ?kd:Float=0, ?ki:Float=0) {
        this.interval = interval;
        this.min = min;
        this.max = max;
        this.kp = kp;
        this.kd = kd;
        this.ki = ki;
    }

    public function calculate(value:Float, ?setpoint:Float=0):Float {
        var error:Float = setpoint - value;
        
        var pOut:Float = error * kp;
        
        var derivative:Float;
        switch (interval.toMilliseconds()) {
            case Milliseconds(timeValue):
                integral += error * timeValue;
                derivative = (error * prevError) / timeValue;
            case _:
                return 0;
        }
        
        var iOut:Float = integral * ki;
        var dOut:Float = derivative * kd;

        var res:Float = pOut + iOut + dOut;
        if (res > max) res = max;
        if (res < min) res = min;

        prevError = error;
        return res;
    }
}