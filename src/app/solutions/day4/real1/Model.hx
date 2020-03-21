package app.solutions.day4.real1;

import image.Pixel;
import trik.Script;
import trik.Brick;
import robotModel.RobotModel;
import app.solutions.day4.real1.Watcher;
import app.solutions.day4.real1.PoolConfig;
import app.solutions.day4.real1.LocalizeAction;
import graph.Node;
import graph.Labyrinth;
import graph.Direction;
import connectionPool.ConnectionPool;

using StringTools;


class Model extends RobotModel {
    override public function solution():Void {
        PoolConfig.watcher = new Watcher(sensorManager);

        var pool = new ConnectionPool(PoolConfig.master, [PoolConfig.slave], [
            PoolConfig.watcher
        ]);
        pool.addActions([
            new LocalizeAction(PoolConfig.master, new Labyrinth(8, 8, executor, sensorManager))
        ]);

        Brick.display.clear();
        Brick.display.addLabel('finish', new Pixel(0,0));
        Brick.display.redraw();
    }
}