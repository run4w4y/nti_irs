package app.tests.scientificTools;

import utest.Test;
import utest.Assert;
import app.tests.exceptions.NoClueException;
import sys.FileSystem in FS;

using StringTools;
using science.ScientificTools;


typedef TestItemInterpolation = {
    input:Array<Array<Float>>,
    result:Array<Array<Float>>,
    testname:String
};

typedef TestItemMedian = {
    input:Array<Float>,
    result:Float,
    testname:String
}

class ScientificToolsTestCase extends Test {
    var testsDir:String;
    var testsInterpolation:Array<TestItemInterpolation>;
    var testsMedian:Array<TestItemMedian>;

    function getTestInput(file:String, testType:String):Dynamic {
        return haxe.Json.parse(Std.string(sys.io.File.read('$testsDir/$testType/$file').readAll()));
    }

    function getTestClue(file:String, testType:String):String {
        if (!FS.exists('$testsDir/$testType/$file.clue'))
            throw new NoClueException('no .clue was found for the $file test');

        return Std.string(sys.io.File.read('$testsDir/$testType/$file.clue').readAll());
    }

    function getTestFiles(testType:String):Array<String> {
        return FS.readDirectory('$testsDir/$testType').filter(
            function(filename:String):Bool {
                if (filename.endsWith('.clue')) 
                    return false;

                return !FS.isDirectory('$testsDir/$testType/$filename');
            }
        );
    }

    public function setup():Void {
        testsInterpolation = [for (file in getTestFiles('interpolation')) {
            input: getTestInput(file, 'interpolation'),
            result: haxe.Json.parse(getTestClue(file, 'interpolation')),
            testname: file
        }];

        testsMedian = [for (file in getTestFiles('median')) {
            input: getTestInput(file, 'median'),
            result: Std.parseFloat(getTestClue(file, 'median')),
            testname: file
        }];
    }

    public function testInterpolation():Void {
        trace('Running interpolation tests.');
        for (test in testsInterpolation) {
            trace('Running test ${test.testname}');
            var f = test.input[0].interpolate1d(test.input[1], true);
            for (i in test.result) {
                Assert.equals(f(i[0]), i[1]);
            }
            trace('Test ${test.testname} - success.');
        }
        trace('Interpolation tests done.');
    }

    public function testMedian():Void {
        trace('Running median tests.');
        for (test in testsMedian) {
            trace('Running test ${test.testname}');
            Assert.equals(test.input.median1d(), test.result);
            trace('Test ${test.testname} - success.');
        }
        trace('Median tests done.');
    }

    public function new(testsDir:String):Void {
        this.testsDir = testsDir;
        super();
    }
}