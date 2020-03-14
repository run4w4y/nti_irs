package connectionPool;

import trik.Mailbox;
import trik.Script;
import ds.HashMap;
import connectionPool.PoolMember;
import connectionPool.Message;


class ConnectionPool {
    var master:PoolMember;
    var slaves = new HashMap<Int, PoolMember>();
    var connected = new HashMap<Int, Bool>();
    var self:PoolMember;

    function isMaster():Bool {
        return self.id == master.id;
    }

    function checkConnection():Bool {
        for (i in connected)
            if (!i) return false;
        return true;
    }

    public function new(master:PoolMember, slaves:Array<PoolMember>) {
        this.master = master;
        for (slave in slaves) {
            this.slaves[slave.id] = slave;
            connected[slave.id] = false;
        }
        var tempId = Mailbox.myHullNumber();
        self = if (tempId == master.id) master else slaves[tempId];

        if (isMaster()) {
            while (!checkConnection()) {
                var slave = Message.receive().sender;
                Mailbox.connect(slave);
                new Message("", self, slave).send();
                connected[slave.id] = true;
            }
            new Message("OK", self).send();
        } else {
            while (!Mailbox.hasMessages()) {
                Mailbox.connect(master);
                new Message("", self, master).send();
                Script.wait(Milliseconds(10));
            }
            while (!Mailbox.hasMessages()) {
                Script.wait(Milliseconds(10));
            }
        }
    }
}