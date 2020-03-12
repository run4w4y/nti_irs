package app.artagDecoder;

import artag.Artag;
import color.BinaryColor;
import ds.Range;
import ds.Bitset;
import movementExecutor.Movement;

using science.ScientificTools;


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

    /**
        Get raw bits read from artag marker

        @returns raw bits from the marker
    **/
    public function readRaw():Bitset {
        var res = [];
        trace(this.marker);
        for (i in 1...this.marker.height - 1)
            res = res.concat(
                if (i == 1 || i == this.marker.height - 2)
                    this.marker[i].slice(2, this.marker.width - 2)
                else
                    this.marker[i].slice(1, this.marker.width - 1)
            );
        return res.map(function (a) return a.value);
    }

    /**
        Get the value decoded from artag marker.

        @returns value encoded in artag marker
    **/
    public function read():Array<Movement> {
        var b:Array<Bitset> = readRaw().decodeHamming().chunks(2);
        return [for (i in b) i.toInt()].map(function (a) {
            return switch (a) {
                case 0: Undefined;
                case 1: TurnLeft;
                case 2: TurnRight;
                case _: Go;
            }
        });
    }
}