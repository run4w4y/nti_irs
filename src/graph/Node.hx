package graph;

import hashmap.Hashable;
import graph.Direction;

using tools.NullTools;


class Node extends Hashable {
	var row:Int;
	var col:Int;
	public var direction: Direction;
	
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

	public function new(row:Int, col:Int, ?direction:Direction) {
		super();
		this.row = row;
		this.col = col;
		this.direction = direction.coalesce(Undefined);
	}
	
	public function changeDirection(direction:Direction) {
		return new Node(row, col, direction);
	}

	public function go(?direction:Direction){
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
	
	public function turnLeft() {
		return new Node(row, col, leftDirection[direction]);
	}
	public function turnRight() {
		return new Node(row, col, rightDirection[direction]);
	}
	public function goBack() {
		var newNode = new Node(row , col, backwardDirection[direction]);
		newNode = newNode.go();
		return newNode.changeDirection(direction);
	}

	public function canGo(allowedDirections:Array<Array<Map<Direction,Bool>>>):Bool {
		return allowedDirections[row][col][direction] == true;
	}
	
	override public function toString():String {
		return 'Node($row, $col, $direction)';
	}
}