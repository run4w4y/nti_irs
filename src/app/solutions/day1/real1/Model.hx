package app.solutions.day1.real1;

import trik.Brick;
import robotModel.RobotModel;
import movementExecutor.Movement;

using StringTools;


class Model extends RobotModel {
    @:inputFrom("real_1")
    static function getInput():String return "";

    override public function solution():Void {
        var actions = [for (i in getInput().trim().split(' ')) switch (Std.parseInt(i)) {
            case 0:
                Undefined;
            case 1:
                TurnLeft;
            case 2: 
                TurnRight;
            case _:
                Go; 
        }].filter(function (x) return x != Undefined);

        for (action in actions)
            executor.add(action);
        executor.execute();

        Brick.display.clear();
        Brick.display.addLabel('finish', new image.Pixel(0, 0));
        Brick.display.redraw();
    }
}