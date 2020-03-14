package connectionPool.request;

class RequestHandler {
    static var nextId = 0;
    public var id:Int;

    public function new() {
        this.id = nextId;
        ++nextId;
    }

    public function call(args:Dynamic):Dynamic {
        return {};
    }
}