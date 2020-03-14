package connectionPool;

import trik.Mailbox;
import haxe.Serializer;
import haxe.Unserializer;
import connectionPool.PoolMember;


class Message {
    public var object:Dynamic;
    public var sender:PoolMember;
    public var receiver:Null<PoolMember>;

    public function new(object:Dynamic, sender:PoolMember, ?receiver:PoolMember) {
        this.object = object;
        this.sender = sender;
        this.receiver = receiver;
    }

    public function send():Void {
        Mailbox.send(Serializer.run(this), receiver);
    }

    public static function receive():Message {
        return Unserializer.run(Mailbox.receive());
    } 
}