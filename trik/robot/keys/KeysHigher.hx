package trik.robot.keys;

import trik.robot.keys.Keys;
import trik.robot.keys.Key;

abstract KeysHigher(Keys) {
    public function keyToCode (key:Key):Int {
        var res:Int = 0;
        switch (key) {
            case Left: 
                res = 105;
            case Up:
                res = 103;
            case Down:
                res = 108;
            case Enter:
                res = 28;
            case Right:
                res = 106;
            case Power:
                res = 116;
            case Esc:
                res = 1;
        }

        return res;
    }

    public function isPressed (key:Key):Bool {
        return this.isPressed(keyToCode(key));
    }

    public function wasPressed (key:Key):Bool {
        return this.wasPressed(keyToCode(key));
    }

    public function new():Void {
        this = untyped __js__("brick.keys()");
    }
}
