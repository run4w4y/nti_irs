package robotModel.sensor;

import trik.Brick;
import trik.robot.sensor.Sensor;
import robotModel.sensor.GenericSensor;
import robotModel.sensor.exceptions.PortException;


class IRSensor implements GenericSensor<Int> {
    var innerSensor:Sensor;

    public function new(port:String) {
        innerSensor = Brick.sensor(port);

        if (innerSensor == null)
            throw new PortException('No sensor on port $port was found');
    }

    @:updateFrequency(10)
    public function read():Int {
        return innerSensor.read();
    }
}