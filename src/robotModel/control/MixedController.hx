package robotModel.control;

import time.Time;
import robotModel.control.MixedArguments;
import robotModel.speedManager.pid.PID;
import robotModel.speedManager.SpeedManager;


class MixedController implements SpeedManager {
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
        this.checkWalls = checkWalls;
        
        wallK = args.wallK;
        gyroK = args.gyroK;
        encodersK = args.encodersK;
        
        var sum = gyroK + wallK + encodersK;
        gyroFullK = sum * gyroK / (gyroK + encodersK);
        encodersFullK = sum - gyroFullK;

        pid = new PID(-40, 40, { kp: .8, kd: .75, ki:.002 });
    }

    public function getError():Float {
        var wallError = getWallError();
        var gyroError = -cast(getGyroError(), Float);
        var encodersError = getEncodersError();
        var res = 
            if (checkWalls()) 
                wallK * wallError + gyroK * gyroError + encodersK * encodersError
            else 
                gyroFullK * gyroError + encodersFullK * encodersError;
        return res;
            
    }

    public function calculate(error:Float):Float {
        return pid.calculate(error);
    }
}