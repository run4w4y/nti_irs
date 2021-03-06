package app.solutions.day3.sim1;

import trik.Script;
import trik.Brick;
import robotModel.RobotModel;
import image.RawImage;
import image.RawHexImage;
import artag.Artag;
import app.artagDecoder.ArtagDecoder;
import image.Pixel;
import movementExecutor.Movement;

using StringTools;


class Model extends RobotModel {
    override public function solution():Void {
        var lines = Script.readAll('input.txt').map(function (x) return x.trim());
        // var img = new RawImage(lines[0].split(' ').map(Std.parseInt)).toImage();
        var img = new RawHexImage(lines[0]).toImage();
        var artag = new Artag(img, false);
        var decoder = new ArtagDecoder(artag);

        for (i in decoder.read().filter(function (x) return x != Undefined))
            executor.add(i);
        executor.execute();

        Brick.display.clear();
        Brick.display.addLabel('finish', new Pixel(0, 0));
        Brick.display.redraw();
    }
}