package connectionPool;

import trik.Mailbox;
import trik.Script;
import ds.HashMap;
import connectionPool.PoolMember;
import connectionPool.message.Message;
import connectionPool.message.MessageType;
import connectionPool.message.Messenger;
import connectionPool.message.ChildMessenger;
import connectionPool.action.PoolAction;
import connectionPool.request.RequestHandler;
import connectionPool.request.RequestForm;
import connectionPool.forward.ForwardHandler;

using tools.NullTools;


class ConnectionPool implements Messenger {
    var master:PoolMember;
    var slaves = new HashMap<Int, PoolMember>();
    var connected = new HashMap<Int, Bool>();
    var self:PoolMember;
    var actions = new HashMap<Int, PoolAction>();
    var handlers = new HashMap<Int, RequestHandler>();
    var forwarder:ForwardHandler;

    function isMaster(?member:PoolMember):Bool {
        return member.coalesce(self).id == master.id;
    }

    function checkConnection():Bool {
        for (i in connected.values())
            if (!i) return false;
        return true;
    }

    public function new(master:PoolMember, slaves:Array<PoolMember>, ?handlers:Array<RequestHandler>) {
        this.master = master;
        this.forwarder = new ForwardHandler();
        initChildMessenger(this.forwarder);

        for (slave in slaves) {
            this.slaves[slave.id] = slave;
            connected[slave.id] = false;
        }

        for (handler in handlers.coalesce([]))
            this.handlers[handler.id] = handler;

        var tempId = Mailbox.myHullNumber();
        self = if (tempId == master.id) master else this.slaves[tempId];
    }

    public function addActions(actions:Array<PoolAction>):Void {
        for (action in
            if (!isMaster())
                actions.filter(function (a) return a.agent.id == self.id)
            else 
                actions
        ) {
            initChildMessenger(action);
            this.actions[action.id] = action;
        }
    }

    function areActionsDone():Bool {
        for (action in actions.values())
            if (action.state != Finished) return false;
        return true;
    }

    public function execute():Void {
        if (isMaster()) {
            for (action in actions.values()) {
                if (action.agent.id == self.id)
                    action.execute();
                else {
                    send(action.id, action.agent);
                    waitForMessage();
                }
            }
            for (slave in slaves.values())
                send('OK', slave);
        } else {
            while (!areActionsDone()) {
                var m = waitForMessage();
                actions[m.object].execute();
                send('OK', master);
            }
            waitForMessage();
        }
    }

    public function waitForResponse():Message {
        while (true) {
            var received = Message.receive();

            switch (received) {
                case Response(m):
                    return m.object;
                case Request(m):
                    response(m);
                case _:
                    continue;
            }
        }
    }

    public function waitForMessage():Message {
        while (true) {
            var received = Message.receive();
            
            switch (received) {
                case Info(m):
                    return m;
                case Request(m):
                    response(m);
                case _:
                    continue;
            }
        }
    }

    public function send(object:Dynamic, ?receiver:PoolMember) {
        if (!isMaster() && !isMaster(receiver))
            request({
                handler: forwarder,
                args: {
                    type: 'Info',
                    object: object,
                    receiver: receiver
                }
            }, master);
        else
            new Message(object, 'Info', self, receiver).send();
    }

    public function request(form:RequestForm, receiver:PoolMember):Dynamic {
        if (!isMaster() && !isMaster(receiver))
            return request({
                handler: forwarder,
                args: {
                    type: 'Request',
                    object: form,
                    receiver: receiver
                }
            }, master);
        else {
            if (receiver.id != self.id) {
                var rawForm = {handlerId: form.handler.id, args: form.args};
                new Message(rawForm, 'Request', self, receiver).send();
                return waitForResponse();
            } else
                return handlers[form.handler.id].call(form.args);
        }
    }

    // TODO: error handling when RequestHandler was not found
    public function response(request:Message) {
        new Message(
            handlers[request.object.handlerId].call(request.object.params), 
            'Response', 
            self, 
            request.sender
        ).send();
    }

    public function initChildMessenger(child:ChildMessenger):Void {
        child.send = send;
        child.request = request;
        child.response = response;
        child.waitForMessage = waitForMessage;
        child.waitForResponse = waitForResponse;
    }
}