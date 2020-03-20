package trik.robot.display;

extern class Display {
    public function addLabel        (text:String, x:Int, y:Int)                             : Void;
    public function clear           ()                                                      : Void;
    public function drawArc         (x:Int, y:Int, l:Int, h:Int, from:Int, to:Int)          : Void;
    public function drawEllipse     (x:Int, y: Int, l:Int, h:Int)                           : Void;
    public function drawLine        (x0:Int, y0:Int, x1:Int, y1:Int)                        : Void;
    public function drawPoint       (x:Int, y:Int)                                          : Void;
    public function drawRect        (x:Int, y:Int, l:Int, h:Int)                            : Void;
    public function hide            ()                                                      : Void;
    public function redraw          ()                                                      : Void;
    public function removeLabels    ()                                                      : Void;
    public function setBackground   (color:String)                                          : Void;
    public function setPainterColor (color:String)                                          : Void;
    public function setPainterWidth (width:Int)                                             : Void;
    public function showImage       (path:String)                                           : Void;
    public function show            (array:Array<Int>, width:Int, height:Int, format:String): Void;
}