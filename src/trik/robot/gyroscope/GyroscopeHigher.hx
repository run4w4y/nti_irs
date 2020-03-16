package trik.robot.gyroscope;

import trik.robot.gyroscope.Gyroscope;
import time.Time;
import angle.Angle;

using tools.TimeTools;


@:forward
abstract GyroscopeHigher(Gyroscope) {
    public function new():Void {
        this = untyped __js__("brick.gyroscope()");
    }

    public function read():Angle {
        return new Angle(this.read()[6]/1000 - 360);
    }

    public function calibrate(duration:Time):Void {
        switch (duration.toMilliseconds()) {
            case Milliseconds(value):
                this.calibrate(value);
            case _:
                return;
        }
    }
}