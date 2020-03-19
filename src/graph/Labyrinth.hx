package graph;

import graph.Node;
import ds.HashMap;
import polygonal.ds.LinkedQueue;
import movementExecutor.Movement;
import movementExecutor.MovementExecutor;
import graph.Direction;
import graph.LabyrinthPoolActions;
import connectionPool.PoolMember;
import connectionPool.ConnectionPool;
import Math.*;

using tools.NullTools;
using Lambda;


typedef ReadFunction = (Void -> Bool);
typedef MoveFunction = (Void -> Void);
typedef DfsArgs = {
	executor:MovementExecutor,
	?readLeft:ReadFunction, 
	?readRight:ReadFunction,
	?readFront:ReadFunction,
	?readBack:ReadFunction
};

typedef RobotActions = {
	addAction:Map<Movement, (Void -> Void)>,
	executeActions:(Void -> Void),
	?readLeft:ReadFunction, 
	?readRight:ReadFunction,
	?readFront:ReadFunction,
	?readBack:ReadFunction
}

class Labyrinth {
	var rows:Int;
	var cols:Int;
	var allowedDirection = new HashMap<Node, Bool>();
	var previousTurn = new HashMap<Node,HashMap<Node,Movement>>();
	var nodes = new Array<Node>();
	var forbiddenPositions = new HashMap<Node,Bool>();
	
	public function new(n:Int, m:Int, ?walls:Array<Array<Int>>) {
		walls = walls.coalesce([]);
		rows = n;
		cols = m;
		nodes = [for (row in 0...rows) for(col in 0...cols) for(direction in [Left,Right,Up,Down])
			new Node(row,col,direction)
		];

		for (node in nodes)
			allowedDirection[node] = true;
		
		for(row in 0...rows) {
			allowedDirection[new Node(row, 0, Left)] = false;
			allowedDirection[new Node(row, cols - 1, Right)] = false;
		}
		
		for(col in 0...cols) {
			allowedDirection[new Node(0, col, Up)] = false;
			allowedDirection[new Node(rows - 1, col, Down)] = false;
		}
		for(wall in walls) {
			var row1 = wall[0], col1 = wall[1], row2 = wall[2], col2 = wall[3];
			if (row1 > row2) {
				var tmp = row2;
				row2 = row1;
				row1 = tmp;
			}
			if (col1 > col2) {
				var tmp = col2;
				col2 = row1;
				col1 = tmp;
			}
			if (col1 == col2) {
				for (row in row1...row2) {
					allowedDirection[new Node(row, col1, Left)] = false;
					allowedDirection[new Node(row, col1 - 1, Right)] = false;
				}
			}
			else {
				for (col in col1...col2) {
					allowedDirection[new Node(row1, col, Up)] = false;
					allowedDirection[new Node(row1 - 1, col, Down)] = false;
				}
			}
		}
	}

	public function init_table(n:Int, m:Int, table:Array<String>) {
		rows = n;
		cols = m;
		nodes = [for (row in 0...rows) for(col in 0...cols) for(direction in [Left,Right,Up,Down])
			new Node(row,col,direction)
		];

		for (node in nodes)
			allowedDirection[node] = true;

		for(row in 0...rows) {
			allowedDirection[new Node(row, 0, Left)] = false;
			allowedDirection[new Node(row, cols - 1, Right)] = false;
		}

		for(col in 0...cols) {
			allowedDirection[new Node(0, col, Up)] = false;
			allowedDirection[new Node(rows - 1, col, Down)] = false;
		}

		for(row in 0...rows) {
			for(col in 0...cols) {
				if(table[row].charAt(col) == "W") {
					for(direction in [Left,Right,Up,Down]){
						var curNode = new Node(row,col,direction);
						if(allowedDirection[curNode]){
							allowedDirection[curNode.go().reverseDirection()] = false;
						}
						allowedDirection[curNode] = false;
					}
				}
			}
		}
  	}


	function bfs(nodeStart:Node) {
		var used = new HashMap<Node, Bool>();
		for (node in nodes) {
			used[node] = false;
		}

		var queue = new LinkedQueue<Node>();
		used[nodeStart] = true;
		queue.enqueue(nodeStart);
		while (!queue.isEmpty()) {
			var currentNode = queue.dequeue();
			var nextNode = currentNode.turnLeft();

			if (!used[nextNode]) {
				queue.enqueue(nextNode);
				used[nextNode] = true;
				previousTurn[nodeStart][nextNode] = TurnLeft;
			}

			nextNode = currentNode.turnRight();
			if (!used[nextNode]) {
				queue.enqueue(nextNode);
				used[nextNode] = true;
				previousTurn[nodeStart][nextNode] = TurnRight;
			}
			if(currentNode.canGo(allowedDirection)){
				nextNode = currentNode.go();
				if (!used[nextNode] && !forbiddenPositions[nextNode]) {
					queue.enqueue(nextNode);
					used[nextNode] = true;
					previousTurn[nodeStart][nextNode] = Go;
				}
			}
		}
	}
	
	public function getPath(nodeFrom:Node, nodeTo:Node, ?forbiddenNodes:List<Node>){
		forbiddenNodes = forbiddenNodes.coalesce(new List<Node>());
		if(nodeFrom.direction == Undefined)
			throw "Undefined starting node direction";
		forbiddenPositions = new HashMap<Node,Bool>();
		
		for(node in forbiddenNodes)
			for(direction in [Left,Right,Up,Down])
				forbiddenPositions[new Node(node.row,node.col,direction)] = true;

		switch (nodeTo.direction) {
			case Undefined:
				var minPath = path(nodeFrom, nodeTo.changeDirection(Left));
				for (i in [Left, Right, Down, Up]) {
					var currentPath = path(nodeFrom, nodeTo.changeDirection(i));
					if(minPath.length > currentPath.length)
						minPath = currentPath;
				}
				return minPath;
			case _:
				return path(nodeFrom, nodeTo);
		}
	}

	function path(nodeFrom:Node, nodeTo:Node): Array<Movement> {
		var currentPath = new Array<Movement>();
		previousTurn[nodeFrom] = new HashMap<Node, Movement>();
		bfs(nodeFrom);
		while(previousTurn[nodeFrom][nodeTo] != null) {
			var currentTurn = previousTurn[nodeFrom][nodeTo];
			currentPath.push(currentTurn);

			switch (currentTurn) {
				case Go: 
					nodeTo = nodeTo.goBack();
				case TurnLeft:
					nodeTo = nodeTo.turnRight();
				case TurnRight:
					nodeTo = nodeTo.turnLeft();
				case TurnAround:
					nodeTo = nodeTo.reverseDirection();
				case Undefined:
					throw "Undefined Movement";
			}
		}
		currentPath.reverse();
		return currentPath;
	}

	var used = new HashMap<Node, Bool>();

	function dfs(
		currentNode:Node, 
		args:DfsArgs
	):Void {
		used[currentNode] = true;
		nodes.push(currentNode);
		trik.Script.print(currentNode);

		allowedDirection[currentNode.turnLeft()] = !args.readLeft();
		
		if (!allowedDirection[currentNode.turnLeft()]){
			used[currentNode.turnLeft()] = true;
			nodes.push(currentNode.turnLeft());
		}
		
		allowedDirection[currentNode.turnRight()] = !args.readRight();

		if (!allowedDirection[currentNode.turnRight()]){
			used[currentNode.turnRight()] = true;
			nodes.push(currentNode.turnRight());
		}
		
		allowedDirection[currentNode] = !args.readFront();

		if (!used[currentNode.turnLeft()] && allowedDirection[currentNode.turnLeft()]) {

			args.executor.add(TurnLeft);
			args.executor.execute();
			
			dfs(currentNode.turnLeft(), args);
			
			args.executor.add(TurnRight);
		}

		if (!used[currentNode.turnRight()] && allowedDirection[currentNode.turnRight()]) {

			args.executor.add(TurnRight);
			args.executor.execute();
			
			dfs(currentNode.turnRight(), args);
			
			args.executor.add(TurnLeft);
		}

		if (!used[currentNode.go()] && allowedDirection[currentNode]) {
			used[currentNode.go().reverseDirection()] = true;
			nodes.push(currentNode.go().reverseDirection());

			args.executor.add(Go);
			args.executor.execute();
			
			dfs(currentNode.go(), args);
			
			args.executor.add(TurnAround);
			args.executor.add(Go);
			args.executor.execute();
			
			args.executor.add(TurnAround);
		};
	}
	public function localizeUndefined(
		startDirection:Direction, 
		executor:MovementExecutor,
		?readLeft:ReadFunction,
		?readRight:ReadFunction,
		?readFront:ReadFunction,
		?readBack:ReadFunction
	):Node {
		var startPoint = new Node(0, 0, startDirection);

		dfs(startPoint, {
			executor: executor,
			readLeft: readLeft,
			readRight: readRight,
			readFront: readFront,
			readBack: readBack
		});

		executor.add(TurnAround);
		executor.execute();
		
		dfs(startPoint.reverseDirection(), {
			executor: executor,
			readLeft: readLeft,
			readRight: readRight,
			readFront: readFront,
			readBack: readBack
		});	

		startDirection = startPoint.reverseDirection().direction;
		var minRow = 0;
		var minCol = 0;

		for (node in nodes) {
			minRow = cast (min(node.row, minRow), Int);
			minCol = cast (min(node.col, minCol), Int);
		}

		var addToRow = cast (abs(minRow), Int);
		var addToCol = cast (abs(minCol), Int);
		var tmpAllowed = new HashMap<Node, Bool>();
		var tmpNodes:Array<Node> = [];
		
		for (node in nodes) {
			var curNode = new Node(node.row + addToRow, node.col + addToCol, node.direction);
			tmpNodes.push(curNode);
			tmpAllowed[curNode] = allowedDirection[node];
		}

		allowedDirection = tmpAllowed;
		nodes = tmpNodes;
		used = new HashMap<Node,Bool>();
		return new Node(addToRow, addToCol, startDirection);
	}

	public function goToClosestPoint(startNode:Node,finishNode:Node):Array<Movement>{
		var nodeStrings = new Array<String>();
		for(node in nodes){
			nodeStrings.push(node.toString());
		}
		var shortPath = [];
		if (nodeStrings.has(new Node(1, 0, Up).toString()))
			trik.Script.print('babababaabababab');
		for(direction in [Left,Right,Down,Up]){
			var nxtNode:Node;
			nxtNode = finishNode.go(direction);
			trik.Script.print(nxtNode);
			if(nodeStrings.has(nxtNode.toString())){
				var path = getPath(startNode, nxtNode.changeDirection(Undefined));
				if(path.length == 0)
					continue;
				if(shortPath.length == 0 || shortPath.length > path.length)
					shortPath = path;
			}
		}
		return shortPath;
	}
	var positionsOfRobots = new HashMap<PoolMember,Node>();
	var found = new HashMap<PoolMember,Bool>();
	var readFunctions = new HashMap<Movement,(Void -> Bool)>();
	var checked = new HashMap<PoolMember,Bool>();
	var allRobots = new List<PoolMember>();
	var readout = new HashMap<PoolMember,HashMap<Movement,Bool>>();
	var temporaryWalls = new HashMap<Node,Bool>();

	function getReadout(robot:PoolMember,pool:ConnectionPool){
		var walls = new HashMap<Movement,Bool>();
		for(move in [TurnLeft,TurnRight,Go,TurnAround]){
			var action = new ReadAction(robot, readFunctions[move]);
			pool.addActions([action]);
			pool.execute();
			walls[move] = !action.res;
		}
		return walls;
	}
	var firstDirection:Direction;

	function getPosition(robot1:PoolMember,robot2:PoolMember, moveToReach:Movement){
		var directionToGo:Direction;
		switch (moveToReach) {
			case Go:
				directionToGo = firstDirection;
			case TurnLeft:
				directionToGo = new Node(0,0,firstDirection).turnLeft().direction;
			case TurnRight:
				directionToGo = new Node(0,0,firstDirection).turnRight().direction;
			case TurnAround:
				directionToGo = new Node(0,0,firstDirection).reverseDirection().direction;
			case _:
				throw "Bad move";
		}
		positionsOfRobots[robot2] = positionsOfRobots[robot1].changeDirection(Up).go(directionToGo);
		found[robot2] = true;
	}

	function dfsWithPool(currentNode:Node, agent:PoolMember, pool:ConnectionPool, args:DfsArgs){
		used[currentNode] = true;
		nodes.push(currentNode);
		for(robot in allRobots){
			if(found[robot])
				continue;
			var newReadout = getReadout(robot,pool);
			for(move in [TurnLeft,TurnRight,TurnAround]){
				if(readout[robot][move] != newReadout[move]){
					readout[robot] = newReadout;
					getPosition(agent,robot,move);
					var posRobot = positionsOfRobots[robot];
					temporaryWalls[posRobot.executeMove(move)] = true;
					var direction = posRobot.executeMove(move).reverseDirection().direction;
					temporaryWalls[currentNode.changeDirection(direction)] = true;
					found[robot] = true;
				}
			}
		}

		getReadout(agent,pool);
		
		for(move in [TurnLeft,TurnRight,TurnAround]){
			var nxtNode:Node;
			switch(move){
				case Go:
					nxtNode = currentNode;
				case _:
					nxtNode = currentNode.executeMove(move);
			}
			allowedDirection[nxtNode] = readout[agent][move];
			if(!allowedDirection[nxtNode]){
				if(!used[nxtNode])
					nodes.push(nxtNode);
				used[nxtNode] = true;	
			}
		}

		for(move in [TurnLeft,TurnRight,TurnAround]){
			if(!allowedDirection[currentNode.executeMove(move)])
				continue;
			
			var nxtNode:Node;
			switch(move){
				case Go:
					nxtNode = currentNode.go();
				case _:
					nxtNode = currentNode.executeMove(move);
			}
			if(used[nxtNode])
				continue;

			if(move == Go){
				if(!used[nxtNode.reverseDirection()])
					nodes.push(nxtNode.reverseDirection());
				used[nxtNode.reverseDirection()] = true;
			}

			pool.addActions([new AddMovementAction(agent,move,args.executor),new ExecuteMovementAction(agent,args.executor)]);
			pool.execute();
			positionsOfRobots[agent] = nxtNode;
			
			dfsWithPool(nxtNode, agent, pool, args);

			positionsOfRobots[agent] = currentNode;
			switch(move){
				case Go:
					pool.addActions([new AddMovementAction(agent,TurnAround,args.executor),new AddMovementAction(agent,Go,args.executor),new ExecuteMovementAction(agent,args.executor)]);
					pool.execute();
					pool.addActions([new AddMovementAction(agent,TurnAround,args.executor)]);
				case TurnLeft:
					pool.addActions([new AddMovementAction(agent,TurnRight,args.executor)]);
				case TurnRight:
					pool.addActions([new AddMovementAction(agent,TurnLeft,args.executor)]);
				case TurnAround:
					pool.addActions([new AddMovementAction(agent,TurnAround,args.executor)]);
				case Undefined:
					throw "Bad move";
			}
		}
	}
	
	function isPositionsNotFound(robots:List<PoolMember>): Bool{
		for(robot in robots)
			if(!found[robot])
				return true;
		return false;
	}
	

	public function localizeWithPool(robots:List<PoolMember>, connectionPool:ConnectionPool,?startDirection:Direction,
		executor:MovementExecutor,
		readLeft:ReadFunction,
		readRight:ReadFunction,
		readFront:ReadFunction,
		readBack:ReadFunction
		): List<Node> {

		startDirection.coalesce(Up);
		firstDirection = startDirection;
		used = new HashMap<Node,Bool>();
		readFunctions[TurnLeft] = readLeft;
		readFunctions[TurnRight] = readRight;
		readFunctions[Go] = readFront;
		readFunctions[TurnAround] = readBack;

		for(robot in robots){
			found[robot] = false; 
			checked[robot] = false;
			readout[robot] = getReadout(robot,connectionPool);
		}

		for(robot in robots){
			for(move in [TurnLeft,TurnRight,Go,TurnAround]){
				if(readout[robot][move]){
					found[robot] = true;
				}
			}
			if(found[robot]){
				positionsOfRobots[robot] = new Node(0,0,startDirection);
				break;
			}
		}
		while(isPositionsNotFound(robots)){
			for(robot in robots){
				if(checked[robot] || !found[robot])
					continue;
				dfsWithPool(positionsOfRobots[robot],robot,connectionPool, {
					executor: executor
				});
				connectionPool.addActions([new ExecuteMovementAction(robot, executor)]);
				connectionPool.execute();
				checked[robot] = true;
			}
		}
		
		var minRow = 0;
		var minCol = 0;

		for (node in nodes) {
			minRow = cast (min(node.row, minRow), Int);
			minCol = cast (min(node.col, minCol), Int);
		}

		var addToRow = cast (abs(minRow), Int);
		var addToCol = cast (abs(minCol), Int);
		var tmpAllowed = new HashMap<Node, Bool>();
		var tmpNodes:Array<Node> = [];
		
		for (node in nodes) {
			var curNode = new Node(node.row + addToRow, node.col + addToCol, node.direction);
			tmpNodes.push(curNode);
			tmpAllowed[curNode] = (allowedDirection[node] || temporaryWalls[node]);
		}
		temporaryWalls = new HashMap<Node,Bool>();
		used = new HashMap<Node,Bool>();
		var positions = new List<Node>();
		for(robot in robots){
			positions.push(positionsOfRobots[robot]);
		}
		return positions;
	}
	public function goToPositionInUnknownLabybrinth(startNode:Node, finishNode:Node,
	executor:MovementExecutor,
	readLeft:ReadFunction,
	readRight:ReadFunction,
	readFront:ReadFunction,
	readBack:ReadFunction): Bool {
		
		used = new HashMap<Node,Bool>();
		readFunctions[TurnLeft] = readLeft;
		readFunctions[TurnRight] = readRight;
		readFunctions[Go] = readFront;
		readFunctions[TurnAround] = readBack;
	
		return dfsToKnownPoint(startNode,finishNode, executor);
	}
	
	function getDistance(node1:Node, node2:Node):Int{
		return cast (abs(node1.row - node2.row), Int) + cast (abs(node1.col - node2.col), Int);
	}

	function dfsToKnownPoint(currentNode:Node,finishNode:Node,executor:MovementExecutor):Bool{
		if (getDistance(currentNode, finishNode) == 0)
			return true;
			
		used[currentNode] = true;
		for (move in [TurnLeft,TurnRight,Go,TurnAround]) {
			var nxtNode:Node;
			switch(move){
				case Go:
					nxtNode = currentNode;
				case _:
					nxtNode = currentNode.executeMove(move);
			}
			allowedDirection[nxtNode] = !readFunctions[move]();
		}
		for (move in [TurnLeft,TurnRight,Go,TurnAround]) {
			var nxtNode:Node;
			switch(move){
				case Go:
					nxtNode = currentNode;
				case _:
					nxtNode = currentNode.executeMove(move);
			}
			if(!allowedDirection[nxtNode]){
				used[nxtNode] = true;
				continue;
			}
			
			if(move == Go){
				nxtNode = nxtNode.go();
			}
			
			if (used[nxtNode])
				continue;
			if (move == Go)
				used[nxtNode.reverseDirection()] = true;
			executor.add(move);
			executor.execute();
			if(dfsToKnownPoint(nxtNode,finishNode,executor))
				return true;
			switch(move){
				case Go:
					executor.add(TurnAround);
					executor.add(Go);
					executor.execute();
					executor.add(TurnAround);
				case TurnLeft:
					executor.add(TurnRight);
				case TurnRight:
					executor.add(TurnLeft);
				case TurnAround:
					executor.add(TurnAround);
				case Undefined:
					throw "Bad move";
			}
		}
		
		return false;
	}
}