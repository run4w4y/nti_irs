package movementExecutor;

import movementExecutor.Movement;
import movementExecutor.exceptions.MovementException;
import robotModel.motorManager.MotorManager;


class MovementExecutor {
    var execQueue:Array<Movement> = [];
    var manager:MotorManager;
    var cellSize:Int;

    public function new(manager:MotorManager, cellSize:Int):Void {
        this.manager = manager;
        this.cellSize = cellSize;
    }

    public function add(movement:Movement):Void {
        switch (movement) {
            case Undefined:
                throw new MovementException('cannot pass Undefined movement to the executor');
            case _:
        }

        execQueue.push(movement);
    }

    public function execute():Void {
        var turnValue = 0;
        for (movement in execQueue) {
            switch (movement) {
                case TurnRight:
                    turnValue += 90;
                case TurnLeft:
                    turnValue -= 90;
                case TurnAround:
                    turnValue += 180;
                case _:
                    if (turnValue != 0)
                        manager.turn(turnValue);
                    turnValue = 0;
                    manager.goEncoders(cellSize);
            }
        }
        if (turnValue != 0)
            manager.turn(turnValue);
        execQueue = [];
    }
}