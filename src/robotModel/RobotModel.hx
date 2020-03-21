package robotModel;

import trik.Script;
import trik.Brick;
import robotModel.motorManager.MotorManager;
import robotModel.sensorManager.SensorManager;
import movementExecutor.MovementExecutor;


class RobotModel {
    var motorManager  :MotorManager;
    var executor      :MovementExecutor;
    var sensorManager :SensorManager;

    function restoreCalibration():Void {
        Brick.gyroscope.setCalibrationValues(Brick.gyroscope.getCalibrationValues());
    }

    public function solution():Void {}

    public function new(cellSize:Int, motorManager:MotorManager, sensorManager:SensorManager):Void {
        // restoreCalibration();
        Script.wait(Seconds(0.5));
        this.motorManager = motorManager;
        this.motorManager.currentDirection = Brick.gyroscope.read();
        this.sensorManager = sensorManager;

        // PoolConfig.watcher = new Watcher(sensorManager);
        
        executor = new MovementExecutor(motorManager, cellSize);
    }
}