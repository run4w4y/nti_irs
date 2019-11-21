package trik.graph;
class Node {
    var x:Int;
    var y:Int;
    var dir:Int;
    public function new(?a:Int, ?b:Int, ?d:Int){
        x = a;
        y = b;
        dir = d;
    }
}
class Graph {
    var Connected:Array<Array<Bool>>;   
    var Dist:Map<Node,Map<Node,Int>>;
    var N:Int;
    var M:Int;
    var Nodes:List<Node>;
    var INF:Int = 1000000;
    public function new(?str:String){
        // Array<String> tmp = str.split("\n");
    }
    function Dijskstra(?st:Node){
        // for(node in Nodes){
        //     Dist[st][node] = 
        // }
    }
}