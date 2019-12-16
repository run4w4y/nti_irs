package src.graph;

import src.graph.Node;
import src.hashmap.HashMap;
import de.polygonal.ds.LinkedQueue;
import src.graph.Movement;
import src.graph.Direction;

class Labyrinth {
	var rows:Int;
	var cols:Int;
	var table = new Array<Array<Bool>>();
	var previousTurn = new HashMap<Node,HashMap<Node,Movement>>();
	var nodes = new Array<Node>();
	public function new(str:String) {
		var splitedStr = str.split("\n");
		var sizeOfStr = splitedStr[0].length;
		for (currentStr in splitedStr)
			if(sizeOfStr != currentStr.length)
				throw "Strings have different lengths";
	
		rows = splitedStr.length;
		cols = sizeOfStr;

		table = [for (i in 0...rows) [for (j in 0...cols) false]];
		for (currentRow in 0...rows) {
			for (currentCol in 0...cols) {
				if(splitedStr[currentRow].charAt(currentCol) == '1')
					table[currentRow][currentCol] = true;
				else
					table[currentRow][currentCol] = false;
				for (i in [Left, Right, Down, Up])
					nodes.push(new Node(currentRow, currentCol, i));
			}
		}

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

		if (!nodeStart.inTable(rows,cols,table))
			return;

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

			nextNode = currentNode.go();
			if(nextNode.inTable(rows,cols,table))
				if (!used[nextNode]) {
					queue.enqueue(nextNode);
					used[nextNode] = true;
					previousTurn[nodeStart][nextNode] = Go;
				}
		}
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