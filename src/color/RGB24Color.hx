package src.color;

import src.color.Color;


class RGB24Color implements Color {
    public var value:Int;
    public var r:Null<Int>;
    public var g:Null<Int>;
    public var b:Null<Int>;

    public function new(value:Int) {
        this.value = value;
        this.r = null;
        this.g = null;
        this.b = null;
    }

    public function toString():String {
        return 'RGB24Color($value)';
    }
}