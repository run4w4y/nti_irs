package connectionPool.message;

import connectionPool.PoolMember;
import connectionPool.message.Message;
import connectionPool.message.ChildMessenger;
import connectionPool.request.RequestForm;


interface Messenger {
    public function send(object:Dynamic, ?receiver:PoolMember):Void;
    public function request(form:RequestForm, receiver:PoolMember):Dynamic;
    public function response(request:Message):Void;
    public function waitForMessage():Message;
    public function waitForResponse():Message;
    public function initChildMessenger(child:ChildMessenger):Void;
}