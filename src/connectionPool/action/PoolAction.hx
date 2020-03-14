package connectionPool.action;

import ds.HashMap;
import connectionPool.message.Message;
import connectionPool.message.Messenger;
import connectionPool.message.Receiver;
import connectionPool.request.RequestForm;
import connectionPool.request.RequestHandler;
import connectionPool.action.ActionState;
import connectionPool.PoolMember;


class PoolAction implements Messenger {
    static var newId = 0;
    public var state:ActionState;
    public var agent:PoolMember;
    public var id:Int;
    public var handlers = new HashMap<Int, RequestHandler>();
    public var members = new HashMap<Int, PoolMember>();

    public function new(action:Void -> Void, agent:PoolMember) {
        state = NotStarted;
        this.agent = agent;
        this.id = newId;
        ++newId;
    }

    public function addHandlers(handlers:Array<RequestHandler>):Void {
        for (handler in handlers) 
            this.handlers[handler.id] = handler;
    }

    public function addMembers(members:Array<PoolMember>):Void {
        for (member in members)
            this.members[member.id] = member;
    }

    function executeInner():Void {}

    public function execute():Void {
        state = Pending;
        executeInner();
        state = Finished;
    }

    public function waitForMessage():Message {
        return Receiver.waitForMessage(response);
    }

    public function waitForResponse():Message {
        return Receiver.waitForResponse(response);
    }

    public function send(object:Dynamic, ?receiver:PoolMember) {
        new Message(object, 'Info', agent, receiver).send();
    }

    public function request(form:RequestForm, receiver:PoolMember):Dynamic {
        var rawForm = {handlerId: form.handler.id, params: form.params};
        new Message(rawForm, 'Request', agent, receiver).send();
        return waitForResponse();
    }

    // TODO: error handling when RequestHandler was not found
    public function response(request:Message) {
        new Message(
            handlers[request.object.handlerId].call(request.object.params), 
            'Response', 
            agent, 
            request.sender
        ).send();
    }
}