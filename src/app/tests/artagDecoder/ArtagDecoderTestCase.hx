package app.tests.artagDecoder;

import app.tests.artag.ArtagTestCase;
import app.artagDecoder.ArtagDecoder;
import artag.Artag;
import color.HexColor;
import color.RGBColor;
import color.BinaryColor;
import image.Image;
import app.artagDecoder.ArtagDecoder;
import science.geometry.Line;
import science.geometry.Point;

using tools.ColorTools;


class ArtagDecoderTestCase extends ArtagTestCase {
    var w = 160;
    var h = 120;

    override public function artagResult(artag:Artag):String {
        return Std.string(new ArtagDecoder(artag).read());
    }

    override public function getTestImage(file:String):Image<RGBColor> {
        var contents = sys.io.File.read('$testsDir/in/$file').readLine().split(' ');
        var res:Array<Array<RGBColor>> = [];

        for (i in 0...h) {
            var tmp:Array<RGBColor> = [];
            for (j in 0...w) {
                var curIndex = w * i + j;
                if (contents[curIndex] != null)
                    tmp.push(new HexColor(contents[curIndex]).toRGB()); 
            }
            res.push(tmp);
        }

        return new Image<RGBColor>(res);
    }

    override public function getTestSize(file:String):Int {
        return 5;
    }
}