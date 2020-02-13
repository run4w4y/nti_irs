package graph;

import graph.Node;
import ds.HashMap;
import polygonal.ds.LinkedQueue;
import movementExecutor.Movement;
import movementExecutor.MovementExecutor;
import graph.Direction;
import Math.*;

using tools.NullTools;


typedef ReadFunction = (Void -> Bool);
typedef MoveFunction = (Void -> Void);
typedef DfsArgs = {
	executor:MovementExecutor,
	?readLeft:ReadFunction, 
	?readRight:ReadFunction,
	?readFront:ReadFunction,
	?readBack:ReadFunction
};

class Labyrinth {
	var rows:Int;
	var cols:Int;
	var allowedDirections = new HashMap<Node, Bool>();
	var previousTurn = new HashMap<Node,HashMap<Node,Movement>>();
	var nodes = new Array<Node>();

	public function new(n:Int, m:Int, ?walls:Array<Array<Int>>) {
		walls = walls.coalesce([]);
		rows = n;
		cols = m;
		nodes = [for (row in 0...rows){for(col in 0...cols){for(direction in [Left,Right,Up,Down]){
					new Node(row,col,direction);
		}}}];

		for (node in nodes)
			allowedDirections[node] = true;
		
		for(row in 0...rows) {
			allowedDirections[new Node(row, 0, Left)] = false;
			allowedDirections[new Node(row, cols - 1, Right)] = false;
		}
		
		for(col in 0...cols) {
			allowedDirections[new Node(0, col, Up)] = false;
			allowedDirections[new Node(rows - 1, col, Down)] = false;
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
					allowedDirections[new Node(row, col1, Left)] = false;
					allowedDirections[new Node(row, col1 - 1, Right)] = false;
				}
			}
			else {
				for (col in col1...col2) {
					allowedDirections[new Node(row1, col, Up)] = false;
					allowedDirections[new Node(row1 - 1, col, Down)] = false;
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
			if(currentNode.canGo(allowedDirections)){
				nextNode = currentNode.go();
				if (!used[nextNode]) {
					queue.enqueue(nextNode);
					used[nextNode] = true;
					previousTurn[nodeStart][nextNode] = Go;
				}}
		}
		// trace("next Node");
	}

	public function getPath(nodeFrom:Node, nodeTo:Node){
		if(nodeFrom.direction == Undefined)
			throw "Undefined starting node direction";
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
					nodeTo = nodeTo.turnLeft().turnLeft();
				case Undefined:
					throw "Undifined Movement";
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

		allowedDirections[currentNode.turnLeft()] = !args.readLeft();
		if (!allowedDirections[currentNode.turnLeft()])
			used[currentNode.turnLeft()] = true;
		allowedDirections[currentNode.turnRight()] = !args.readRight();
		if (!allowedDirections[currentNode.turnRight()])
			used[currentNode.turnRight()] = true;
		allowedDirections[currentNode] = !args.readFront();

		if (!used[currentNode.turnLeft()] && allowedDirections[currentNode.turnLeft()]) {
			args.executor.add(TurnLeft);
			args.executor.execute();
			dfs(currentNode.turnLeft(), args);
			args.executor.add(TurnRight);
		}

		if (!used[currentNode.turnRight()] && allowedDirections[currentNode.turnRight()]) {
			args.executor.add(TurnRight);
			args.executor.execute();
			dfs(currentNode.turnRight(), args);
			args.executor.add(TurnLeft);
		}

		if (!used[currentNode.go()] && allowedDirections[currentNode]) {
			used[currentNode.go().reverseDirection()] = true;
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
			tmpAllowed[curNode] = allowedDirections[node];
		}

		allowedDirections = tmpAllowed;
		nodes = tmpNodes;
		
		return new Node(addToRow, addToCol, startDirection);
	}
}