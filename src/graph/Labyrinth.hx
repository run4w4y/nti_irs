package graph;

import graph.Node;
import hashmap.HashMap;
import polygonal.ds.LinkedQueue;
import graph.Movement;
import graph.Direction;
import Math.*;

using tools.NullTools;


typedef ReadFunction = (Void -> Bool);
typedef MoveFunction = (Void -> Void);
typedef DfsArgs = {
	turnLeft:MoveFunction,
	turnRight:MoveFunction,
	turnBack:MoveFunction,
	goForth:MoveFunction,
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
				previousTurn[nodeStart][nextNode] = RotateLeft;
			}

			nextNode = currentNode.turnRight();
			if (!used[nextNode]) {
				queue.enqueue(nextNode);
				used[nextNode] = true;
				previousTurn[nodeStart][nextNode] = RotateRight;
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
				case RotateLeft:
					nodeTo = nodeTo.turnRight();
				case RotateRight:
					nodeTo = nodeTo.turnLeft();
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
		previousMove:Movement,
		args:DfsArgs
	):Bool {
		used[currentNode] = true;
		nodes.push(currentNode);

		allowedDirections[currentNode.turnLeft()] = !args.readLeft();
		if (!allowedDirections[currentNode.turnLeft()])
			used[currentNode.turnLeft()] = true;
		allowedDirections[currentNode.turnRight()] = !args.readRight();
		if (!allowedDirections[currentNode.turnRight()])
			used[currentNode.turnRight()] = true;
		allowedDirections[currentNode] = !args.readFront();

		if (!used[currentNode.turnLeft()] && !args.readLeft()) {
			args.turnLeft();
			if(!dfs(currentNode.turnLeft(), RotateLeft, args))
				args.turnRight();
		}

		if (!used[currentNode.turnRight()] && !args.readRight()) {
			args.turnRight();
			if(!dfs(currentNode.turnRight(), RotateRight, args))
				args.turnLeft();
		}

		if (!used[currentNode.go()] && !args.readFront()) {
			used[currentNode.go().reverseDirection()] = true;
			args.goForth();
			if(!dfs(currentNode.go(), Go, args))
				args.turnBack();
			args.goForth();
			switch (previousMove){
				case RotateLeft:
					args.turnLeft();
					return true;
				case RotateRight:
					args.turnRight();
					return true;
				case Go:
					return true;
				case Undefined:
					args.turnBack();
					return false;
			}
		}
		return false;
	}

	public function localizeUndefined(
		startDirection:Direction, 
		turnLeft:MoveFunction,
		turnRight:MoveFunction,
		turnBack:MoveFunction,
		goForth:MoveFunction,
		?readLeft:ReadFunction,
		?readRight:ReadFunction,
		?readFront:ReadFunction,
		?readBack:ReadFunction
	):Node {

		var startPoint = new Node(0, 0, startDirection);

		dfs(startPoint, 
			Undefined, {
			turnLeft: turnLeft,
			turnRight: turnRight,
			turnBack: turnBack,
			goForth: goForth,
			readLeft: readLeft,
			readRight: readRight,
			readFront: readFront,
			readBack: readBack
		});
		turnBack();
		dfs(startPoint.reverseDirection(), 
			Undefined, {
			turnLeft: turnLeft,
			turnRight: turnRight,
			turnBack: turnBack,
			goForth: goForth,
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