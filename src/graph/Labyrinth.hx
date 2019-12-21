package h;

import h.Node;
import map.HashMap;
import de.polygonal.ds.LinkedQueue;
import h.Movement;
import h.Direction;

class Labyrinth {
	var rows:Int;
	var cols:Int;
	var allowedDirections = new Array<Array<Map<Direction,Bool>>>();
	var previousTurn = new HashMap<Node,HashMap<Node,Movement>>();
	var nodes = new Array<Node>();
	public function new(n:Int, m:Int, walls:List<Array<Int>>) {
		rows = n;
		cols = m;
		allowedDirections = [for (i in 0...rows) [for (j in 0...cols) [
			Left => true,	Right =>true,
			Down => true,	Up => true
		]]];
		
		for(row in 0...rows){
			allowedDirections[row][0][Left] = false;
			allowedDirections[row][cols - 1][Right] = false;
		}
		
		for(col in 0...cols){
			allowedDirections[0][col][Up] = false;
			allowedDirections[rows - 1][col][Down] = false;
		}
		for(wall in walls){
			var row1 = wall[0], col1 = wall[1], row2 = wall[2], col2 = wall[3];
			if(row1 > row2){
				var tmp = row2;
				row2 = row1;
				row1 = tmp;
			}
			if(col1 > col2){
				var tmp = col2;
				col2 = row1;
				col1 = tmp;
			}
			if(col1 == col2){
				for(row in row1...row2){
					allowedDirections[row][col1][Left] = false;
					allowedDirections[row][col1 - 1][Right] = false;
				}
			}
			else{
				for(col in col1...col2){
					allowedDirections[row1][col][Up] = false;
					allowedDirections[row1 - 1][col][Down] = false;
				}
			}
		}
		nodes = [for (row in 0...rows){for(col in 0...cols){for(direction in [Left,Right,Up,Down]){
					new Node(row,col,direction);
		}}}];
		for (node in nodes) {
			previousTurn[node] = new HashMap<Node,Movement>();
			bfs(node);
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
			}
		}
		currentPath.reverse();
		return currentPath;
	}
}