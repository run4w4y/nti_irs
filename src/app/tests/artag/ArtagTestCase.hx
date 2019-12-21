package src.app.tests.artag;

import haxe.unit.TestCase;
import src.color.RGBColor;
import src.color.BinaryColor;
import src.image.Image;
import src.artag.Artag;
import json2object.JsonParser;
import json2object.JsonWriter;
import src.geometry.Line;
import src.geometry.Point;
import src.geometry.PointLike;
import src.tools.ColorTools.*;
import src.app.tests.artag.exceptions.NoClueException;
import src.app.tests.artag.exceptions.NoSizeException;
import sys.FileSystem in FS;

using src.tools.ImageTools;
using src.tools.GeometryTools;
using StringTools;
using Lambda;


typedef TestItem = {
    size:Int,
    input:Image<RGBColor>,
    result:String,
    testname:String
}

class ArtagTestCase extends TestCase {
    var artag:Artag;
    var tests:Array<TestItem>;
    public var testsDir = 'tests/artagTests';

    public function getTestSize(file:String):Int {
        if (!FS.exists('$testsDir/in/$file.size'))
            throw new NoSizeException('no .size was found for the $file test');

        return Std.parseInt(sys.io.File.read('$testsDir/in/$file.size').readLine());
    }

    public function getTestImage(file:String):Image<RGBColor> {
        var parser = new JsonParser<Array<Array<Array<Int>>>>();
        return new Image<RGBColor> (
            parser.fromJson(Std.string(sys.io.File.read('$testsDir/in/$file').readAll()), "errors.txt").map(
                function(array:Array<Array<Int>>) return array.map(
                    function (triple:Array<Int>) return new RGBColor(triple[0], triple[1], triple[2])
                )
            )
        );
    }

    public function getTestClue(file:String) {
        if (!FS.exists('$testsDir/in/$file.clue'))
            throw new NoClueException('no .clue was found for the $file test');

        return Std.string(sys.io.File.read('$testsDir/in/$file.clue').readAll());
    }

    override public function setup():Void {
        var files:Array<String> = FS.readDirectory('$testsDir/in').filter(
            function(filename:String):Bool {
                if (filename.endsWith('.clue') || filename.endsWith('.size')) 
                    return false;

                return !FS.isDirectory('$testsDir/in/$filename');
            }
        );

        tests = [for (file in files) {
            size: getTestSize(file),
            input: getTestImage(file),
            result: getTestClue(file),
            testname: file
        }];
    } 

    function getPixelString(pixel:src.image.Pixel):String {
        return 'pt ${pixel.x} ${pixel.y}\n';
    }

    function getPointString<T:PointLike>(pointLike:T):String {
        return 'pt ${pointLike.x} ${pointLike.y}\n';
    }

    function getLineString(line:Line):String {
        return 'ln\n ${getPointString(line.point1)} ${getPointString(line.point2)}\n';
    }

    public function markerToString(marker:Image<BinaryColor>):String {
        var res = '';
        for (i in marker) {
            for (j in i)
                res += if (j.value) 1 else 0;
            res += '\n';
        }
        return res.trim();
    }

    public function artagResult(artag:Artag):String {
        return markerToString(artag.marker);
    }

    public function testMarkers():Void {
        var writer = new JsonWriter<Array<Array<Int>>>();

        trace('Running artag tests.');
        for (test in tests) {
            trace('Running test "${test.testname}"');
            var artag = new Artag(test.input, false, test.size);

            sys.io.File.write('$testsDir/out/${test.testname}.binimg').writeString(
                writer.write(artag.image.map(
                    function(array:Array<BinaryColor>) return array.map(
                        function(color:BinaryColor) return toMono(color).value
                    )
                ))
            );

            var plotOut = "";
            for (i in artag.getCells())
                for (j in i) {
                    plotOut += getPixelString(j.leftTop);
                    plotOut += getPixelString(j.leftBottom);
                    plotOut += getPixelString(j.rightTop);
                    plotOut += getPixelString(j.rightBottom);
                }

            sys.io.File.write('$testsDir/out/${test.testname}.grid').writeString(plotOut);
            sys.io.File.write('$testsDir/out/${test.testname}.marker').writeString(markerToString(artag.marker));

            assertTrue(artag.checkMarker());
            assertEquals(test.result.trim(), artagResult(artag));
            trace('Test "${test.testname}" - success.');
        }
        trace('Artag tests done.');
    }

    public function new(testsDir:String):Void {
        this.testsDir = testsDir;
        super();
    }
}