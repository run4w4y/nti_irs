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
        var goValue = 0;
        
        for (movement in execQueue) {
            // trik.Script.print(goValue);
            switch (movement) {
                case TurnRight:
                    if (goValue != 0)
                        manager.goEncoders(goValue);
                    goValue = 0;
                    turnValue += 90;
                case TurnLeft:
                    if (goValue != 0)
                        manager.goEncoders(goValue);
                    goValue = 0;
                    turnValue -= 90;
                case TurnAround:
                    if (goValue != 0)
                        manager.goEncoders(goValue);
                    goValue = 0;
                    turnValue += 180;
                case _:
                    if (turnValue != 0)
                        manager.turn(turnValue);
                    turnValue = 0;
                    goValue += cellSize;
            }
        }
        if (turnValue != 0)
            manager.turn(turnValue);
        if (goValue != 0)
            manager.goEncoders(goValue);
        execQueue = [];
    }
}