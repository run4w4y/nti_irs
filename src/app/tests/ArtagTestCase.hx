package src.app.tests;

import haxe.unit.TestCase;
import src.trik.color.RGBColor;
import src.trik.color.BinaryColor;
import src.trik.image.Image;
import src.trik.artag.Artag;
import json2object.JsonParser;
import json2object.JsonWriter;
import src.trik.geometry.Line;
import src.trik.geometry.Point;
import src.trik.tools.ColorTools.*;
import src.app.tests.exceptions.NoClueException;
import sys.FileSystem in FS;

using src.trik.tools.ImageTools;
using src.trik.tools.GeometryTools;
using StringTools;
using Lambda;


typedef TestItem = {
    input:Image<RGBColor>,
    result:String,
    testname:String
}

class ArtagTestCase extends TestCase {
    var artag:Artag;
    var tests:Array<TestItem>;
    var testsDir = 'tests/artagTests';

    override public function setup():Void {
        var parser = new JsonParser<Array<Array<Array<Int>>>>();
        var files:Array<String> = FS.readDirectory('$testsDir/in').filter(
            function(filename:String):Bool {
                if (filename.endsWith('.clue')) 
                    return false;

                if (!FS.exists('$testsDir/in/$filename.clue'))
                    throw new NoClueException('no .clue was found for the $filename test');

                return !FS.isDirectory('$testsDir/in/$filename');
            }
        );

        tests = [for (file in files) {
            input: new Image<RGBColor> (
                parser.fromJson(Std.string(sys.io.File.read('$testsDir/in/$file').readAll()), "errors.txt").map(
                    function(array:Array<Array<Int>>) return array.map(
                        function (triple:Array<Int>) return new RGBColor(triple[0], triple[1], triple[2])
                    )
                )
            ),
            result: Std.string(sys.io.File.read('$testsDir/in/$file').readAll()),
            testname: file
        }];
    } 

    public function testMarkers():Void {
        var writer = new JsonWriter<Array<Array<Int>>>();

        for (test in tests) {
            var artag = new Artag(test.input, false);

            sys.io.File.write('$testsDir/out/${test.testname}.out').writeString(
                writer.write(artag.image.map(
                    function(array:Array<BinaryColor>) return array.map(
                        function(color:BinaryColor) return toMono(color).value
                    )
                ))
            );

            assertTrue(artag.checkMarker());
        }
    }
}