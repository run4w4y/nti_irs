package ds;

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

    @:from
    public static function fromInt(n:Int):Bitset {
        var l = Std.int(Math.log(n) / Math.log(2)) + 1;
        return [for (i in 0...l) (n >> (l - 1 - i)) & 1];
    }

    @:to
    public function toInt():Int {
        return [for (i in 0...this.length) if (this[i]) Std.int(Math.pow(2, this.length - i - 1)) else 0].sum();
    }

    static function isPowerOfTwo(n:Int):Bool {
        if (n == 0) return false;
        var t = Math.log(n) / Math.log(2);
        return Math.ceil(t) == Math.floor(t);
    }

    static function getBits(n:Int, seq:Bitset):Bitset {
        var res:Bitset = [];
        
        var t:Array<Bitset> = seq.slice_(n).chunks(n);
        for (i in 0...t.length)
            if (i % 2 == 0) res = res.concat(t[i]);
        
        trace(n, seq, t.map(function (a) return a.toString()), res);

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
                error += Std.int(Math.pow(i, 2));
        
        return (if (error == 0) removeHammingBits() else inverse(error).removeHammingBits());
    }

    public function inverse(index:Int):Bitset {
        var res = this;
        res[index] = !res[index];
        return res;
    }

    public function toString():String {
        return '0b' + this.map(function (a) return switch (a) {
            case true:  '1';
            case false: '0';
            case null:  'N';
        }).join('');
    }
}