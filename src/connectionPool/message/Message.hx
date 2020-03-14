package connectionPool.message;

import exceptions.ValueException;
import trik.Mailbox;
import haxe.Serializer;
import haxe.Unserializer;
import connectionPool.PoolMember;
import connectionPool.message.MessageType;

using Lambda;
using haxe.EnumTools;


class Message {
    public var object:Dynamic;
    public var sender:PoolMember;
    public var receiver:Null<PoolMember>;
    public var constructor:String;

    public function new(object:Dynamic, constructor:String, sender:PoolMember, ?receiver:PoolMember) {
        if (!MessageType.getConstructors().has(constructor))
            throw new ValueException('constructor parameter must be name of one of the MessageType constructors');

        this.object = object;
        this.sender = sender;
        this.receiver = receiver;
        this.constructor = constructor;
    }

    public function send():Void {
        Mailbox.send(Serializer.run(MessageType.createByName(constructor, [this])), receiver);
    }

    public static function receive():MessageType {
        return Unserializer.run(Mailbox.receive());
    } 
}