package trik.color;

import trik.color.Color;


class MonoColor implements Color {
    public var value:Int;
    public var r:Null<Int>;
    public var g:Null<Int>;
    public var b:Null<Int>;

    public function new(value:Int):Void {
        if (value < 0 || value > 255) throw "value of mono color has to be in the range [0; 255]";

        this.value = value;
    }
}