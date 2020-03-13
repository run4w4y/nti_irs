package app.tests.hamming;

import utest.Test;
import utest.Assert;
import ds.Bitset;


class HammingTestCase extends Test {
    function checkInput(input:Bitset):Void {
        Assert.equals(input.removeHammingBits(), input.decodeHamming());
        for (_ in 0...Std.int(input.length / 2))
            Assert.equals(input.removeHammingBits(), input.inverse(Std.random(input.length)).decodeHamming());
    }

    public function testHamming1():Void {
        var tests:Array<Bitset> = [
            [1,1,1,0,1,0,0,0,0,0,0,0,0,1,0,1,1,0,1,0,1,1,0,1,0,0,0,1,0,1,0,0],
            [0,1,1,1,1,1,1,1,1,0,0,1,0,1,0,0,1,1,1,0,0,1,0,0,1,0,0,0,1,0,0,0],
            [0,1,1,1,1,0,1,1,0,1,1,0,0,1,0,0,0,1,0,0,1,0,0,1,1,1,0,1,0,0,0,0]
        ];
        for (test in tests)
            checkInput(test);
    }
}