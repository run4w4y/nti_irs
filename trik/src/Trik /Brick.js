'use strict';

exports.getBrickUncurried = function(encoder_ports, motor_ports, sensor_ports) {
    var newbrick;
    newbrick.accelerometer = brick.accelerometer();
    newbrick.battery = brick.battery();
    newbrick.colorSensor = brick.colorSensor();
    newbrick.display = brick.display();
    newbrick.gyroscope = brick.gyroscope();
    newbrick.keys = brick.keys();
    newbrick.led = brick.led();
}

exports.brickSayUncurried = function(defbrick, string) {
    defbrick.say(string);
    return 0;
}

exports.playSoundUncurried = function(defbrick, filename) {
    defbrick.playSound(filename);
    return 0;
}

exports.brickStop = function(defbrick) {
    defbrick.stop();
    return 0;
}
