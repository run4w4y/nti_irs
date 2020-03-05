package color;

/**
    Interface for colors. All the colors must have R, G and B fields. 
**/
interface Color {
    public var r(get, null):Int;
    public var g(get, null):Int;
    public var b(get, null):Int;
    public function toString():String;
}