package app.solutions.day1.real2;

import trik.Script;
import trik.Brick;
import robotModel.RobotModel;
import graph.Node;
import graph.Labyrinth;

using StringTools;


class Model extends RobotModel {
    @:inputFrom("real_2")
    static function getInput():String return "";

    override public function solution():Void {
        var lines = getInput().split('\n').map(
            function (x) 
                return x.trim().split(' ').map(Std.parseInt)
        ).filter(function (x) return x[0] != null);

        var startNode = new Node(lines[0][1], lines[0][0], switch (lines[0][2]) {
            case 0: Up;
            case 1: Right;
            case 2: Down;
            case _: Left;
        });
        var finishNode = new Node(lines[1][1], lines[1][0], Undefined);
        var g = new Labyrinth(8, 8);
        var res = g.goToPositionInUnknownLabybrinth(
            startNode, finishNode, executor, 
            sensorManager.checkLeft.bind(), 
            sensorManager.checkRight.bind(), 
            sensorManager.checkFront.bind(), 
            sensorManager.checkBack.bind()
        );

        Script.print(res);

        Brick.display.clear();
        Brick.display.addLabel('finish', new image.Pixel(0, 0));
        Brick.display.redraw();
    }
}