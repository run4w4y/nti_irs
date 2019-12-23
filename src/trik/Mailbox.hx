package trik;

class Mailbox {
    public static function connect(ip:String, ?port:Int=-1):Void {
        if (port == -1) 
            untyped __js__("mailbox.connect({0})", ip);
        else
            untyped __js__("mailbox.connect({0}, {1})", ip, port);
    }

    public static function hasMessages():Bool {
        return untyped __js__("mailbox.hasMessages()");
    }

    public static function myHullNumber():Int {
        return untyped __js__("mailbox.myHullNumber()");
    }

    public static function receive():String {
        return untyped __js__("mailbox.receive()");
    }

    public static function send(message:String, ?robotNumber:Int=-1):Void {
        if (robotNumber == -1)
            untyped __js__("mailbox.send({0})", message);
        else
            untyped __js__("mailbox.send({0}, {1})", robotNumber, message);
    }
}