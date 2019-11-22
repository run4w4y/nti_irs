package trik.graph;

import trik.hashmap.Hashable;
import trik.graph.Direction;

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
		this.direction = if (direction != null) direction else Up;
	}
	
	public function changeDirection(direction:Direction) {
		return new Node(row, col, direction);
	}
	
	public override function toString():String{
		var str = "Node " + row + " " + col + " ";
		switch (direction) {
			case Left:
				str += "Left";
			case Right:
				str += "Right";
			case Down:
				str += "Down";
			case Up:
				str += "Up";
			case Undefined:
				str += "Undefined";
		}
		return str;
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

	public function inTable(rows:Int, cols:Int, table:Array<Array<Bool>>):Bool {
		if(row >= rows || row < 0 || col >= cols || col < 0)
			return false;
		if(table[row][col])
			return false;
		return true;
	}
	
}