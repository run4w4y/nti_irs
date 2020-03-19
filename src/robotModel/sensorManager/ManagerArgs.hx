package robotModel.sensorManager;

import robotModel.sensor.GenericSensor;


typedef ManagerArgs = {
    ?frontSensor:GenericSensor<Int>,
    ?leftSensor:GenericSensor<Int>,
    ?backSensor:GenericSensor<Int>,
    ?rightSensor:GenericSensor<Int>
}