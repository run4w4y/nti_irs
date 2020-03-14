package trik;

import connectionPool.PoolMember;


class Mailbox {
    public static function connect_(ip:String, ?port:Int):Void {
        if (port == null) 
            untyped __js__("mailbox.connect({0})", ip);
        else
            untyped __js__("mailbox.connect({0}, {1})", ip, port);
    }

    public static function connect(member:PoolMember):Void {
        connect_(member.ip, member.port);
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

    public static function send(message:String, ?member:PoolMember):Void {
        if (member == null)
            untyped __js__("mailbox.send({0})", message);
        else
            untyped __js__("mailbox.send({0}, {1})", member.id, message);
    }
}