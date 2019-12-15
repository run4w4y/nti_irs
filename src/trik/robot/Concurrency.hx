package src.trik.robot;

class Concurrency {
    public function joinThread(threadId:String):Void {
        untyped __js__("Threading.joinThread({0})", threadId);
    }

    public function killThread(threadId:String):Void {
        untyped __js__("Threading.killThread({0})", threadId);
    }

    public function receiveMessage(wait:Bool):String {
        return untyped __js__("Threading.receiveMessage({0})", wait);
    }

    public function sendMessage(threadId:String, message:String):Void {
        return untyped __js__("Threading.sendMessage({0}, {1})", threadId, message);
    }

    public function startThread(threadId:String, functionName:String):Void {
        return untyped __js__("Threading.startThread({0}, {1})", threadId, functionName);
    }

    public function new() {}
}