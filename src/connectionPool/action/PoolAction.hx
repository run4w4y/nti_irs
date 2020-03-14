package connectionPool.action;

import connectionPool.action.ActionState;
import connectionPool.PoolMember;


class PoolAction {
    public var state:ActionState;
    public var agent:PoolMember;
    var action:Void -> Void;

    public function new(action:Void -> Void, agent:PoolMember) {
        state = NotStarted;
        this.agent = agent;
        this.action = action;
    }

    public function execute():Void {
        state = Pending;
        action();
        state = Finished;
    }
}