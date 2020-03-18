package graph;

import graph.Direction;
import ds.HashMap;
import movementExecutor.Movement;
using tools.NullTools;


class Node {
	public var row:Int;
	public var col:Int;
	public var direction:Direction;
	
	var leftDirection:Map<Direction,Direction> = [
		Left  => Down, 	Down => Right,
		Right => Up,	Up   => Left
	];
	
	var rightDirection:Map<Direction,Direction> = [
		Down => Left, 	Right => Down,
		Up   => Right,	Left  => Up
	];
	
	var backwardDirection:Map<Direction,Direction> = [
		Down  => Up,	Up   => Down,
		Right => Left,	Left => Right
	];

	public function new(row:Int, col:Int, ?direction:Direction):Void {
		this.row = row;
		this.col = col;
		this.direction = direction.coalesce(Undefined);
	}
	
	public function changeDirection(direction:Direction):Node {
		return new Node(row, col, direction);
	}
	public function executeMove(move:Movement){
		switch(move){
			case TurnLeft:
				return new Node(row,col,leftDirection[direction]);
			case TurnRight:
				return new Node(row,col,rightDirection[direction]);
			case TurnAround:
				return new Node(row,col,backwardDirection[direction]);
			case Go:
				return go();
			case Undefined:
				throw "undefined move";
		}
	}
	public function go(?direction:Direction):Node {
		direction = if(direction != null) direction else this.direction;
		switch (direction) {
			case Left:
				return new Node(row, col - 1, direction);
			case Right:
				return new Node(row, col + 1, direction);
			case Up:
				return new Node(row - 1, col, direction);
			case Down:
				return new Node(row + 1, col, direction);
			case Undefined:
				throw "Moving in undefined direction";
		}
	}
	
	public function turnLeft():Node {
		return new Node(row, col, leftDirection[direction]);
	}

	public function turnRight():Node {
		return new Node(row, col, rightDirection[direction]);
	}

	public function goBack():Node {
		var newNode = new Node(row, col, backwardDirection[direction]);
		newNode = newNode.go();
		return newNode.changeDirection(direction);
	}

	public function reverseDirection():Node {
		return new Node(row, col, backwardDirection[direction]);
	}

	public function canGo(allowedDirections:HashMap<Node, Bool>):Bool {
		return allowedDirections[this];
	}
	
	public function toString():String {
		return 'Node($row, $col, $direction)';
	}
}