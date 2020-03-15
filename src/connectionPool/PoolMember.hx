package connectionPool;

class PoolMember {
    public var ip:Null<String>;
    public var port:Null<Int>;
    public var id:Int;

    public function new(id:Int, ?ip:String, ?port:Int) {
        this.ip = ip;
        this.port = port;
        this.id = id;
    }
}