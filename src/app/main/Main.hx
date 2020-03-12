package app.main;

import trik.Brick;
import trik.Script;
import image.Image;
import image.RawImage;
import artag.Artag;
import app.artagDecoder.ArtagDecoder;
import image.Pixel;


class Main {
    public static function main():Void {
        var img = new RawImage(Script.readAll('input.txt')[0]).toImage();
        var artag = new Artag(img);
        var values = new ArtagDecoder(artag).read();
        Brick.display.addLabel(
            values.map(function (a) return switch(a) {
                case Go:        'F';
                case TurnRight: 'R';
                case TurnLeft:  'L';
                case _:         'N';
            }).join(' '),
            new Pixel(0, 0)
        );
    }
}