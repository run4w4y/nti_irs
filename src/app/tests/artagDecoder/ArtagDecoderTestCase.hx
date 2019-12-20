package src.app.tests.artagDecoder;

import src.app.tests.artag.ArtagTestCase;
import src.app.artagDecoder.ArtagDecoder;
import src.artag.Artag;
import src.color.HexColor;
import src.color.RGBColor;
import src.color.BinaryColor;
import src.image.Image;
import src.app.artagDecoder.ArtagDecoder;
import src.geometry.Line;
import src.geometry.Point;
import src.geometry.PointLike;
import src.tools.ColorTools.*;

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
                    tmp.push(new HexColor(contents[curIndex]).toRgb()); 
            }
            res.push(tmp);
        }

        return new Image<RGBColor>(res);
    }

    override public function getTestSize(file:String):Int {
        return 5;
    }
}