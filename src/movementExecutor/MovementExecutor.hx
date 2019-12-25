package movementExecutor;

import movementExecutor.Movement;
import movementExecutor.exceptions.MovementException;


class MovementExecutor {
    var execQueue:Array<Movement> = [];
    var turn:(Int) -> Void;
    var go:Void -> Void;

    public function new(
        turn:(Int) -> Void,
        go:Void -> Void
    ):Void {
        this.turn = turn;
        this.go = go;
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
                    turnValue -= 90;
                case TurnLeft:
                    turnValue += 90;
                case TurnAround:
                    turnValue += 180;
                case _:
                    if (turnValue != 0)
                        turn(turnValue);
                    turnValue = 0;
                    go();
            }
        }
        if (turnValue != 0)
            turn(turnValue);
        execQueue = [];
    }
}
