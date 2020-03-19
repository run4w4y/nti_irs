package robotModel.sensorManager;

import robotModel.sensorManager.SensorManager;
import robotModel.sensorManager.BaseManager;
import robotModel.sensorManager.ManagerArgs;


class RealManager extends BaseManager implements SensorManager {
    public function new(args:ManagerArgs) {
        super(args, 50);
    }
}