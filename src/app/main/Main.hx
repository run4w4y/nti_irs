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
        var img = new RawImage(Script.readAll('input.txt')[0], Hex).toImage();
        var artag = new Artag(img, true, 8);
        var decoder = new ArtagDecoder(artag);
        Script.print(decoder.readRaw());
        var values = decoder.read();
        var ans = values.map(function (a) return switch(a) {
            case Go:        '3';
            case TurnRight: '2';
            case TurnLeft:  '1';
            case _:         '0';
        }).join(' ');
        Brick.display.addLabel(ans, new Pixel(0, 0));
        Script.print(ans);
    }
}