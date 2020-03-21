package app.solutions.day4.real1;

import app.solutions.day4.real1.Watcher;
import app.solutions.day4.real1.PoolConfig;
import connectionPool.action.PoolAction;
import connectionPool.PoolMember;
import graph.Labyrinth;


class LocalizeAction extends PoolAction {
    var g:Labyrinth;

    public function new(agent:PoolMember, g:Labyrinth) {
        super(agent);
        this.g = g;
    }

    override function executeInner():Void {
        g.localizeUndefined(Up, request.bind({
            handler: PoolConfig.watcher
        }, PoolConfig.slave));
    } 
}
