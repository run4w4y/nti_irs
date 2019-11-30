package trik;

import trik.robot.Brick;
import trik.robot.ScriptHigher;
import trik.robot.Mailbox;
import trik.robot.Concurrency;


class Trik {
    public static var brick = new Brick();
    public static var script = new ScriptHigher();
    public static var mailbox = new Mailbox();
    public static var threading = new Concurrency();

    public static function print(text:Any):Void {
        untyped __js__("print({0})", text);
    }
}