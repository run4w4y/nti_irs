package src.trik.robot;

import src.trik.robot.Script;
import src.time.Time;

using src.tools.TimeTools;


@:forward
abstract ScriptHigher(Script) {
    public function new():Void {
        this = untyped __js__('script');
    }

    public function time():Time {
        return Milliseconds(this.time());
    }

    public function wait(duration:Time):Void {
        switch (duration.toMilliseconds()) {
            case Milliseconds(value):
                this.wait(value);
            case _:
                return;
        }
    }
}