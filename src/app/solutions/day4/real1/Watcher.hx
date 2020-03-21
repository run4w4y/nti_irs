package app.solutions.day4.real1;

import connectionPool.request.RequestHandler;
import robotModel.sensorManager.SensorManager;
import app.solutions.day4.real1.WatcherRes;

class Watcher extends RequestHandler {
    var prevLeft:Bool;
    var prevRight:Bool;
    var prevFront:Bool;
    var prevBack:Bool;
    var sensorManager:SensorManager;

    public function new(sensorManager:SensorManager):Void {
        super();
        prevLeft = sensorManager.checkLeft();
        prevRight = sensorManager.checkRight();
        prevFront = sensorManager.checkFront();
        prevBack = sensorManager.checkBack();
        this.sensorManager = sensorManager;
    }

    override public function call(_:Dynamic):Dynamic {
        if (prevLeft != sensorManager.checkLeft())
            return FoundLeft;
        if (prevRight != sensorManager.checkRight())
            return FoundRight;
        if (prevFront != sensorManager.checkFront())
            return FoundFront;
        if (prevBack != sensorManager.checkBack())
            return FoundBack;
        return NotFound;
    }
}