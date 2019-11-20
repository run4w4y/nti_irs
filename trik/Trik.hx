package trik;

import trik.robot.Brick;
import trik.robot.Script;
import trik.robot.Mailbox;


class Trik {
    public static var brick = new Brick();
    public static var script = new Script();
    public static var mailbox = new Mailbox();

    public static function print(text:Any):Void {
        untyped __js__("print({0})", text);
    }
}