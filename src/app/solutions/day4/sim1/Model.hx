package app.solutions.day4.sim1;

import image.Pixel;
import trik.Script;
import trik.Brick;
import robotModel.RobotModel;
import movementExecutor.Movement;
import graph.Node;
import graph.Labyrinth;
import graph.Direction;

using StringTools;


class Model extends RobotModel {
    override public function solution():Void {
        var lines = Script.readAll('input.txt').map(function (x) return x.trim().split(' ').map(Std.parseInt)).filter(function (x) return x[0] != null);
        var startDir = switch (lines[0][0]) {
            case 0: 
                Up;
            case 1:
                Right;
            case 2:
                Down;
            case _:
                Left;
        };
        var blockedNode = new Node(lines[1][1], lines[1][0]);
        Script.print(blockedNode);
        var g = new Labyrinth(8, 8, executor, sensorManager);
        var node = g.localizeUndefined(startDir, blockedNode);
        Script.print(node);
        Brick.display.clear();
        Brick.display.addLabel('(${node.col},${node.row})', new Pixel(0,0));
        Brick.display.redraw();
    }
}