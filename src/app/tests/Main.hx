package app.tests;

import utest.Runner;
import utest.ui.Report;
import app.tests.artag.ArtagTestCase;
import app.tests.artagDecoder.ArtagDecoderTestCase;


class Main {
    public static function main() {
        var runner = new Runner();
        runner.addCase(new ArtagTestCase('tests/artagTests'));
        runner.addCase(new ArtagDecoderTestCase('tests/artagDecoderTests'));
        Report.create(runner);
        runner.run();
    }
}