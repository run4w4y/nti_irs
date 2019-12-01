package trik.tools;

class NullTools {
    @:generic
    public static function coalesce<T>(value:Null<T>, defaultValue:T):T {
        return if (value == null) defaultValue else value;
    }
}