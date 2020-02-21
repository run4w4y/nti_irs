package app.artagDecoder;

import artag.Artag;
import color.BinaryColor;
import ds.Range;


/**
    Class for decoding the artag marker. Note: to read the artag marker from image use Artag class.
**/
abstract ArtagDecoder(Artag) {
    /**
        Class constructor.

        @param artag artag which needs to be decoded.
    **/
    public function new(artag:Artag):Void {
        this = artag;
    }

    function binaryToInt(str:String):Int {
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

    /**
        Get the value decoded from artag marker.

        @returns value encoded in artag marker
    **/
    public function read():Int {
        return binaryToInt(
            Std.string(colorToDigit(this.marker[1][2])) + 
            Std.string(colorToDigit(this.marker[2][1])) + 
            Std.string(colorToDigit(this.marker[2][3])) + 
            Std.string(colorToDigit(this.marker[3][2]))
        );
    }
}