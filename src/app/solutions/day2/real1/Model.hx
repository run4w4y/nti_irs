package app.solutions.day2.real1;

import trik.Brick;
import trik.Script;
import robotModel.RobotModel;
import graph.Direction;
import graph.Labyrinth;

using StringTools;


class Model extends RobotModel {
    @:inputFrom("real_1")
    inline function getInput():String return "";

    override public function solution():Void {
        var raw = Std.parseInt(getInput().trim());
        var input = switch (raw) {
            case 0: Up;
            case 1: Right;
            case 2: Down;
            case _: Left;
        };

        var g = new Labyrinth(8, 8);
        var startNode = g.localizeUndefined(input, executor, null, checkLeft, checkRight, checkFront, checkBack);

        Brick.display.clear();
        Brick.display.addLabel('(${startNode.col},${startNode.row})', new image.Pixel(0, 0));
        Brick.display.redraw();
        Script.wait(Seconds(1));
        Brick.say('ooo');
    }
}