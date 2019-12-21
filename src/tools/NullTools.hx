package tools;

class NullTools {
    public static function coalesce<T>(value:Null<T>, defaultValue:T):T {
        return if (value == null) defaultValue else value;
    }
}