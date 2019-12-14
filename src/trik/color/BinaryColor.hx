package trik.color;

import trik.color.Color;


class BinaryColor implements Color {
    public var r:Null<Int>;
    public var g:Null<Int>;
    public var b:Null<Int>;
    public var value:Bool; // 0 - white, 1 - black

    public function new(value:Bool):Void {
        this.value = value;
    }

    public function inverse():BinaryColor {
        return new BinaryColor(!this.value);
    }

    public function toString():String {
        return 'BinaryColor($value)';
    }
}