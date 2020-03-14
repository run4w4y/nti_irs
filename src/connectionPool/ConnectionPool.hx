package connectionPool;

import trik.Mailbox;
import trik.Script;
import time.Time;
import ds.HashMap;
import connectionPool.PoolMember;


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
                var slave = slaves[Std.parseInt(Mailbox.receive())];
                Mailbox.connect(slave);
                Mailbox.send("OK", slave);
                connected[slave.id] = true;
            }
        } else {
            while (!Mailbox.hasMessages()) {
                Mailbox.connect(master);
                Mailbox.send("${self.id}");
                Script.wait(Milliseconds(10));
            }
        }
    }
}