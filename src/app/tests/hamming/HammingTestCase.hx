package app.tests.hamming;

import utest.Test;
import utest.Assert;
import ds.Bitset;


class HammingTestCase extends Test {
    function checkInput(input:Bitset):Void {
        Assert.equals(input.toString(), input.addHammingBits().decodeHamming().toString());
        var add = 0;
        for (_ in 0...Std.int(input.length)){
            while(input.isPowerOfTwo(add + _ + 1)){
                add++;
            }
            Assert.equals(input.toString(), input.addHammingBits().inverse(_ + add).decodeHamming().toString());
        } 
    }

    public function testHamming1():Void {
        var tests:Array<Bitset> = [
             [1,1,1,0,1,0,0,0,0,0,0,0,0,1,0,1,1,0,1,0,1,1,0,1,0,0,0,1,0,1,0,0],
             [0,1,1,1,1,1,1,1,1,0,0,1,0,1,0,0,1,1,1,0,0,1,0,0,1,0,0,0,1,0,0,0],
             [1,1,1,1]
        ];
        for (test in tests)
            checkInput(test);
    }
}