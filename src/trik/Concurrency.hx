package trik;

class Concurrency {
    public static function joinThread(threadId:String):Void {
        untyped __js__("Threading.joinThread({0})", threadId);
    }

    public static function killThread(threadId:String):Void {
        untyped __js__("Threading.killThread({0})", threadId);
    }

    public static function receiveMessage(wait:Bool):String {
        return untyped __js__("Threading.receiveMessage({0})", wait);
    }

    public static function sendMessage(threadId:String, message:String):Void {
        return untyped __js__("Threading.sendMessage({0}, {1})", threadId, message);
    }

    public static function startThread(threadId:String, functionName:String):Void {
        return untyped __js__("Threading.startThread({0}, {1})", threadId, functionName);
    }
}