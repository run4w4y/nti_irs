package science.matrix;

using tools.NullTools;


@:forward
abstract Matrix<T>(Array<Array<T>>) from Array<Array<T>> to Array<Array<T>> {
    public var width(get, never):Int;
    public var height(get, never):Int;

    private function get_width():Int {
        if (height == 0)
            return 0;

        return this[0].length;
    }

    private function get_height():Int {
        return this.length;
    }

    public function new(?a:Array<Array<T>>) {
        this = a.coalesce([]);
    }

    @:op([]) public inline function getIndex(i:Int):Array<T> {
        return this[i];
    }

    @:op([]) public inline function setIndex(i:Int, value:Array<T>):Array<T> {
        return this[i] = value;
    }
}