package src.app.tests;

import haxe.unit.TestRunner;
import src.app.tests.artag.ArtagTestCase;


class Main {
    public static function main() {
        var runner = new TestRunner();
        runner.add(new ArtagTestCase());
        runner.run();
    }
}