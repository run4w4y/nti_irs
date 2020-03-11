package ds;

using tools.NullTools;
using science.ScientificTools;


@:forward
abstract Bitset(Array<Bool>) from Array<Bool> to Array<Bool> {
    public function new():Void {
        this = [];
    }

    @:from
    public static function fromIntArray(a:Array<Int>):Bitset {
        return [for (i in a) i == 1];
    }

    @:to
    public function toIntArray():Array<Int> {
        return [for (i in this) if (i) 1 else 0];
    }

    static function isPowerOfTwo(n:Int):Bool {
        if (n == 0) return false;
        var t = Math.log(n) / Math.log(2);
        return Math.ceil(t) == Math.floor(t);
    }

    static function getBits(n:Int, seq:Bitset):Bitset {
        var res = [];
        var indexId = n - 1;

        while (indexId < seq.length) {
            res = res.concat(seq.slice(indexId, indexId + cast(Math.min(n, seq.length - indexId), Int)));
            indexId += 2 * n;
        }

        return res;
    }

    public function addHammingBits():Bitset {
        var res = [];
        var hammingIndexes = [];
        var i = 0;
        var t = 0;

        while (t < this.length) {
            ++i;
            if (isPowerOfTwo(i)) {
                hammingIndexes.push(i - 1);
                res.push(false);
            } else {
                res.push(this[t]);
                ++t;
            }
        }

        for (i in hammingIndexes)
            res[i] = getBits(i + 1, res).filter(function (a) return a).length % 2 != 0;
        
        return res;
    }

    public function getHammingBits():Bitset {
        var res = [];
        for (i in 0...this.length)
            if (isPowerOfTwo(i + 1)) res.push(this[i]);
        return res;
    }

    public function removeHammingBits():Bitset {
        var res = [];
        for (i in 0...this.length) 
            if (!isPowerOfTwo(i + 1)) res.push(this[i]);
        return res;
    }

    public function decodeHamming():Bitset {
        var actual = getHammingBits();
        var expected = removeHammingBits().addHammingBits().getHammingBits();
        var error = 0;

        for (i in 0...actual.length)
            if (actual[i] != expected[i])
                error += cast(Math.pow(i, 2), Int);
        
        return (if (error == 0) removeHammingBits() else inverse(error).removeHammingBits());
    }

    public function inverse(index:Int):Bitset {
        var res = this;
        res[index] = !res[index];
        return res;
    }
}