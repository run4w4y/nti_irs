package app.tests;

import utest.Runner;
import utest.ui.Report;
import app.tests.artag.ArtagTestCase;
import app.tests.scientificTools.ScientificToolsTestCase;
import app.tests.hamming.HammingTestCase;


class Main {
    public static function main() {
        var runner = new Runner();
        runner.addCase(new ArtagTestCase('tests/artagTests'));
        runner.addCase(new ScientificToolsTestCase('tests/scientificToolsTests'));
        runner.addCase(new HammingTestCase());
        Report.create(runner);
        runner.run();
    }
}