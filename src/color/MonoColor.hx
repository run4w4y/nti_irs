package src.color;

import src.color.Color;
import src.exceptions.ValueException;


class MonoColor implements Color {
    public var value:Int;
    public var r:Null<Int>;
    public var g:Null<Int>;
    public var b:Null<Int>;

    public function new(value:Int):Void {
        if (value < 0 || value > 255) 
            throw new ValueException("value of mono color has to be in the range [0; 255]");

        this.value = value;
    }

    public function toString():String {
        return 'MonoColor($value)';
    }
}