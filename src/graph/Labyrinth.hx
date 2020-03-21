package graph;

import graph.Node;
import ds.HashMap;
import polygonal.ds.LinkedQueue;
import movementExecutor.Movement;
import movementExecutor.MovementExecutor;
import robotModel.sensorManager.SensorManager;
import graph.Direction;
import graph.LabyrinthPoolActions;
import connectionPool.PoolMember;
import connectionPool.ConnectionPool;
import app.solutions.day4.real1.WatcherRes;
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
	var executor:MovementExecutor;
	var sensors:SensorManager;
	var allowedDirection = new HashMap<Node, Bool>();
	var previousTurn = new HashMap<Node,HashMap<Node,Movement>>();
	var nodes = new Array<Node>();
	var forbiddenPositions = new HashMap<Node,Bool>();
	
	public function new(n:Int, m:Int, executor:MovementExecutor, sensorManager:SensorManager,?walls:Array<Array<Int>>) {
		walls = walls.coalesce([]);
		rows = n;
		cols = m;
		this.executor = executor;
		sensors = sensorManager;
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

	function bfs(nodeStart:Node) {
		var used = new HashMap<Node, Bool>();
		previousTurn[nodeStart] = new HashMap<Node,Movement>();
		var queue = new LinkedQueue<Node>();
		used[nodeStart] = true;
		queue.enqueue(nodeStart);
		// trik.Script.print(allowedDirection[new Node(3,-3,Right)]);
		while (!queue.isEmpty()) {
			var currentNode = queue.dequeue();
			var nextNode = currentNode.turnLeft();
			// trik.Script.print(currentNode);

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
			if(allowedDirection[currentNode]){
				nextNode = currentNode.go();
				if (!used[nextNode]) {
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
	var localized = false;
	var found = false;
	
	var addToRow = -1;
	var addToCol = -1;
	
	var minRow = 0;
	var minCol = 0;
	var maxRow = 0;
	var maxCol = 0;

	var requestF:Void -> Dynamic;
	function getCheck(curNode:Node):Null<Node> {
		if(localized && found){
			return otherNode;
		}
		if(localized){
			var res = requestF();
			switch(res) {
				case NotFound:
					return null;
				case _:
					otherNode = curNode;
			}
			trik.Brick.say('aaaaa');
			trik.Script.wait(Seconds(10));
			found = true;
			return otherNode;
		}
		for (node in nodes) {
			minRow = cast (min(node.row, minRow), Int);
			minCol = cast (min(node.col, minCol), Int);
			maxRow = cast (max(node.row, maxRow), Int);
			maxCol = cast (max(node.col, maxCol), Int);
		}
		nodes = new Array<Node>();
		if (!found) {
			var res = requestF();
			switch(res) {
				case NotFound:
					return null;
				case _:
					otherNode = curNode;
			}
			trik.Brick.say('aaaaa');
			trik.Script.wait(Seconds(10));
			found = true;
		}

		if (maxRow - minRow + 1 != rows || maxCol - minCol + 1 != cols) 
			return null;
		
		localized = true;
		addToRow = cast (abs(minRow), Int);
		addToCol = cast (abs(minCol), Int);

		if(localized && found)
			return curNode;
		return null;
	}
	var realNode:Node;
	var otherNode:Node;
	function alignNodes(finishNode:Node){
		var moves = getPath(realNode,finishNode);
		for(move in moves)
			executor.add(move);
		executor.execute();
		realNode = finishNode;
	}

	function undoneDfs(currentNode:Node):Null<Node> {
		alignNodes(currentNode);

		for(direction in [Left,Right,Up,Down]){
			used[currentNode.changeDirection(direction)] = true;
			nodes.push(currentNode.changeDirection(direction));
		}

		allowedDirection[currentNode.turnLeft()] = !sensors.checkLeft();

		allowedDirection[currentNode.turnRight()] = !sensors.checkRight();

		allowedDirection[currentNode.reverseDirection()] = !sensors.checkBack();
		
		allowedDirection[currentNode] = !sensors.checkFront();

		var tmp = getCheck(currentNode);
		
		if(tmp != null)
			return tmp;

		if (!used[currentNode.turnLeft().go()] && allowedDirection[currentNode.turnLeft()]) {

			var node = undoneDfs(currentNode.turnLeft().go());
			if(node != null)
				return node; 
			
		}

		if (!used[currentNode.turnRight().go()] && allowedDirection[currentNode.turnRight()]) {

			var node = undoneDfs(currentNode.turnRight().go());
			if(node != null)
				return node; 
		}

		if (!used[currentNode.go()] && allowedDirection[currentNode]) {
			var node = undoneDfs(currentNode.go());
			if(node != null)
				return node;  
		}

		if (!used[currentNode.reverseDirection().go()] && allowedDirection[currentNode.reverseDirection()]) {
			var node = undoneDfs(currentNode.reverseDirection().go());
			if(node != null)
				return node;  
		}

		return null;
	}

	public function localizeUndefined(startDirection:Direction, requestF:() -> Dynamic):Node {
		this.requestF = requestF;
		var startPoint = new Node(0, 0, startDirection);
		realNode = startPoint;
		nodes = new Array<Node>();
		allowedDirection = new HashMap<Node,Bool>();
		var node = undoneDfs(startPoint);
		if(node != null){
			alignNodes(startPoint);
		}
		return null;
	}

}