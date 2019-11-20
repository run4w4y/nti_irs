package trik.robot.keys;

enum Key {
    Left;
    Up;
    Down;
    Enter;
    Right;
    Power;
    Esc;
}

private extern class Keys {
    public function isPressed  (key:Int) :Bool;
    public function reset      ()        :Void;
    public function wasPressed (key:Int) :Bool;
}

class KeysHigher extends Keys {
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

    public function isKeyPressed (key:Key):Bool {
        return super.isPressed(keyToCode(key));
    }

    public function wasKeyPressed (key:Key):Bool {
        return super.wasPressed(keyToCode(key));
    }
}