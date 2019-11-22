// import trik.robot.motor.Motor;
// import trik.Trik.*;
// import trik.color.Color;
// import trik.color.ColorTools.*;
// import trik.robot.keys.Key;
import trik.hashmap.HashMap;
import trik.hashmap.Hashable;

using Lambda;

class Foo extends Hashable {
    var a:Int;

    public function new (a:Int) {
        super();
        this.a = a;
    }

    public override function toString ():String {
        return "Foo(" + a + ")";
    }
}

class Main {
    public static function main():Void {
        var m = new HashMap<Foo, Int>();
        var f = new Foo(1);
        m[f] = 1;
        trace(m[f]);
        trace(m[new Foo(1)]);
    }
}