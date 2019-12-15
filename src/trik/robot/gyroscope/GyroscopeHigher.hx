package src.trik.robot.gyroscope;

import src.trik.robot.gyroscope.Gyroscope;
import src.trik.time.Time;

using src.trik.tools.TimeTools;


@:forward
abstract GyroscopeHigher(Gyroscope) {
    public function new():Void {
        this = untyped __js__("brick.gyroscope()");
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