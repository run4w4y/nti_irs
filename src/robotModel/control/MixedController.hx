package robotModel.control;

import time.Time;
import robotModel.control.MixedArguments;
import robotModel.speedManager.pid.PID;


class MixedController {
    var checkWalls:Void -> Bool;
    var getWallError:Void -> Int;
    var getGyroError:Void -> Float;
    var getEncodersError:Void -> Int;
    var wallK:Float;
    var gyroK:Float;
    var encodersK:Float;
    var gyroFullK:Float;
    var encodersFullK:Float;
    var pid:PID;

    public function new(interval:Time, checkWalls:Void -> Bool, args:MixedArguments):Void {
        getEncodersError = args.getEncodersError;
        getGyroError = args.getGyroError;
        getWallError = args.getWallError;
        
        wallK = args.wallK;
        gyroK = args.gyroK;
        encodersK = args.encodersK;
        
        var sum = gyroK + wallK + encodersK;
        gyroFullK = sum * gyroK / (gyroK + encodersK);
        encodersFullK = sum - gyroFullK;

        pid = new PID(interval, -40, 40, { kp: .8, kd: .75, ki:.002 });
    }

    public function calculate():Float {
        var error = 
            if (checkWalls()) 
                wallK * getWallError() + gyroK * getGyroError() + encodersK * getEncodersError()
            else 
                gyroFullK * getGyroError() + encodersFullK * getEncodersError();
        return pid.calculate(error);
    }
}