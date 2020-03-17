package graph;

import connectionPool.PoolMember;
import connectionPool.ConnectionPool;
import connectionPool.action.PoolAction;
import connectionPool.request.RequestHandler;

import movementExecutor.Movement;
import movementExecutor.MovementExecutor;

class AddMovementAction extends PoolAction {
	//maybe executor might not work
	var move:Movement;
	var executor:MovementExecutor;
	override public function new(agent:PoolMember, move:Movement, executor:MovementExecutor){
		super(agent);
		this.move = move;
		this.executor = executor;
	}
    override function executeInner() {
        executor.add(move);
    }
}

class ExecuteMovementAction extends PoolAction {
    var executor:MovementExecutor;
	override public function new(agent:PoolMember, executor:MovementExecutor){
		super(agent);
		this.executor = executor;
	}
	override function executeInner() {
        executor.execute();
    }
}
class ReadHandler extends RequestHandler {
	var read:( Void -> Bool );
	public override function new(read:(Void -> Bool)){
		super();
		this.read = read;
	}
    override public function call(_:Dynamic):Dynamic {
        return read();
    }
}

class ReadAction extends PoolAction {
	var read: Void -> Bool;
	public var res:Bool;
	override public function new(agent:PoolMember, read:(Void -> Bool)){
		super(agent);
		this.read = read;
	}
    override function executeInner() {
        var res = request({handler:new ReadHandler(read)}, agent);
    }
}