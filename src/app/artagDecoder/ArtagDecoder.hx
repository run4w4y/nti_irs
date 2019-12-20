package src.app.artagDecoder;

import src.artag.Artag;
import src.color.BinaryColor;
import src.range.Range;


abstract ArtagDecoder(Artag) {
    public function new(artag:Artag):Void {
        this = artag;
    }

    function binaryToInt(str:String):Int {
        trace(str);
        var res = 0;
        var cur = 1;

        for (i in new Range(str.length - 1, -1)) {
            res += Std.parseInt(str.charAt(i)) * cur;
            cur *= 2;
        }

        return res;
    }

    function colorToDigit(color:BinaryColor):Int {
        return if (color.value) 1 else 0;
    }

    public function read():Int {
        return binaryToInt(
            Std.string(colorToDigit(this.marker[1][2])) + 
            Std.string(colorToDigit(this.marker[2][1])) + 
            Std.string(colorToDigit(this.marker[2][3])) + 
            Std.string(colorToDigit(this.marker[3][2]))
        );
    }
}