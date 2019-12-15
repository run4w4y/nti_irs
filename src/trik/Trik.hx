package trik;

import src.trik.robot.Brick;
import src.trik.robot.ScriptHigher;
import src.trik.robot.Mailbox;
import src.trik.robot.Concurrency;


class Trik {
    public static var brick = new Brick();
    public static var script = new ScriptHigher();
    public static var mailbox = new Mailbox();
    public static var threading = new Concurrency();

    public static function print(obj:Dynamic):Void {
        untyped __js__("print({0})", Std.string(obj));
    }
}