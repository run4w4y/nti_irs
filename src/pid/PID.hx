package src.pid;

import src.time.Time;
import src.pid.PIDCoefficients;
import Math.*;

using src.tools.TimeTools;
using src.tools.NullTools;


class PID {
    var interval  :Time;
    var min       :Float;
    var max       :Float;
    var kp        :Float;
    var kd        :Float;
    var ki        :Float;
    var prevError :Float = 0;
    var integral  :Float = 0;

    public function new(interval:Time, min:Float, max:Float, ks:PIDCoefficients) {
        this.interval = interval;
        this.min = min;
        this.max = max;
        this.kp = ks.kp;
        this.kd = ks.kd.coalesce(0);
        this.ki = ks.ki.coalesce(0);
    }

    public function calculate(error:Float):Float {
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