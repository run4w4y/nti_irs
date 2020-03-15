package connectionPool.action;

import connectionPool.message.Message;
import connectionPool.message.ChildMessenger;
import connectionPool.action.ActionState;
import connectionPool.PoolMember;
import connectionPool.message.Types;


class PoolAction implements ChildMessenger {
    static var newId = 0;
    public var state:ActionState;
    public var agent:PoolMember;
    public var id:Int;
    public var send:SendFunction;
    public var request:RequestFunction;
    public var response:ResponseFunction;
    public var waitForMessage:WaitFunction;
    public var waitForResponse:WaitFunction;

    public function new(agent:PoolMember) {
        state = NotStarted;
        this.agent = agent;
        this.id = newId;
        ++newId;
    }

    function executeInner():Void {}

    public function execute():Void {
        state = Pending;
        executeInner();
        state = Finished;
    }
}