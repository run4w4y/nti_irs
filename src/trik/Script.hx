package trik;

import time.Time;

using tools.TimeTools;


class Script {
    public static function quit():Void {
        untyped __js__("script.quit()");
    }

    public static function random(from:Int, to:Int):Int {
        return untyped __js__("script.random({0}, {1})", from, to);
    }

    public static function readAll(filename:String):Array<String> {
        return untyped __js__("script.readAll({0})", filename);
    }

    public static function removeFile(filename:String):Void {
        untyped __js__("script.removeFile({0})", filename);
    }

    public static function run():Void {
        untyped __js__("script.run()");
    }

    public static function system(command:String):Void {
        untyped __js__("script.system({0})", command);
    }

    public static function time():Time {
        return Milliseconds(untyped __js__("script.time()"));
    }

    // skipped function script.timer because that would be too bothersome to deal with class QTimer

    public static function wait(duration:Time):Void {
        switch (duration.toMilliseconds()) {
            case Milliseconds(value):
                untyped __js__("script.wait({0})", value);
            case _:
                return;
        };
    }

    public static function writeToFile(filename:String, content:String) {
        return untyped __js__("script.writeToFile({0}, {1})", filename, content);
    }

    public static function print(obj:Dynamic):Void {
        untyped __js__("print({0})", Std.string(obj));
    }
}