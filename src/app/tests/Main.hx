package src.app.tests;

import haxe.unit.TestRunner;
import src.app.tests.artag.ArtagTestCase;
import src.app.tests.artagDecoder.ArtagDecoderTestCase;


class Main {
    public static function main() {
        var runner = new TestRunner();
        // runner.add(new ArtagTestCase());
        runner.add(new ArtagDecoderTestCase('tests/artagDecoderTests'));
        runner.run();
    }
}