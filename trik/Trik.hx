package trik;

import trik.robot.Brick;
import trik.robot.ScriptHigher;
import trik.robot.Mailbox;
import trik.robot.Concurrency;


typedef Printable = {
    public function toString():String;
}

class Trik {
    public static var brick = new Brick();
    public static var script = new ScriptHigher();
    public static var mailbox = new Mailbox();
    public static var threading = new Concurrency();

    @:generic
    public static function print<T:Printable>(obj:T):Void {
        untyped __js__("print({0})", Std.string(obj));
    }
}