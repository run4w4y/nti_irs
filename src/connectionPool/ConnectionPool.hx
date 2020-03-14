package connectionPool;

import trik.Mailbox;
import trik.Script;
import ds.HashMap;
import connectionPool.PoolMember;
import connectionPool.message.Message;
import connectionPool.message.MessageType;
import connectionPool.message.Messenger;
import connectionPool.message.Receiver;
import connectionPool.action.PoolAction;
import connectionPool.request.RequestHandler;
import connectionPool.request.RequestForm;

using tools.NullTools;


class ConnectionPool implements Messenger {
    var master:PoolMember;
    var slaves = new HashMap<Int, PoolMember>();
    var connected = new HashMap<Int, Bool>();
    var self:PoolMember;
    var actions = new HashMap<Int, PoolAction>();
    var handlers = new HashMap<Int, RequestHandler>();

    inline function isMaster():Bool {
        return self.id == master.id;
    }

    function checkConnection():Bool {
        for (i in connected.values())
            if (!i) return false;
        return true;
    }

    public function new(master:PoolMember, slaves:Array<PoolMember>, ?handlers:Array<RequestHandler>) {
        this.master = master;

        for (slave in slaves) {
            this.slaves[slave.id] = slave;
            connected[slave.id] = false;
        }

        for (handler in handlers.coalesce([]))
            this.handlers[handler.id] = handler;

        var tempId = Mailbox.myHullNumber();
        self = if (tempId == master.id) master else slaves[tempId];

        if (isMaster()) {
            while (!checkConnection()) {
                var slave = waitForMessage().sender;
                Mailbox.connect(slave);
                send('', slave);
                connected[slave.id] = true;
            }
            send('OK');
        } else {
            while (!Mailbox.hasMessages()) {
                Mailbox.connect(master);
                send('', master);
                Script.wait(Milliseconds(10));
            }
            waitForMessage();
        }
    }

    public function addActions(actions:Array<PoolAction>):Void {
        for (action in
            if (!isMaster())
                actions.filter(function (a) return a.agent.id == self.id)
            else 
                actions
        ) {
            action.addHandlers(handlers.values());
            action.addMembers(slaves.values());
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
        } else
            while (!areActionsDone())
                actions[waitForMessage().object].execute();
    }

    public function waitForMessage():Message {
        return Receiver.waitForMessage(response);
    }

    public function waitForResponse():Message {
        return Receiver.waitForResponse(response);
    }

    public function send(object:Dynamic, ?receiver:PoolMember) {
        new Message(object, 'Info', self, receiver).send();
    }

    public function request(form:RequestForm, receiver:PoolMember):Dynamic {
        var rawForm = {handlerId: form.handler.id, params: form.params};
        new Message(rawForm, 'Request', self, receiver).send();
        return waitForResponse();
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
}