'use strict';

exports.getBrickUncurried = function(encoder_ports, motor_ports, sensor_ports) {
    var newbrick = {};
    newbrick.accelerometer = brick.accelerometer();
    newbrick.battery = brick.battery();
    newbrick.colorSensor = {};
    newbrick.display = brick.display();
    newbrick.gyroscope = brick.gyroscope();
    newbrick.keys = brick.keys();
    newbrick.led = brick.led();
    newbrick.encoders = [];
    for (var i = 0; i < encoder_ports.length; ++i) {
        newbrick.encoders[i] = brick.encoder("E" + encoder_ports[i].value0);
        newbrick.encoders[i].value0 = encoder_ports[i];
    }
    newbrick.motors = [];
    for (var i = 0; i < motor_ports.length; ++i) {
        if (motor_ports[i].constructor.name == "ServoMotorPort")
            newbrick.motors[i] = brick.motor("S" + motor_ports[i].value0);
        else
            newbrick.motors[i] = brick.motor("M" + motor_ports[i].value0);
        newbrick.motors[i].value0 = motor_ports[i];
    }
    newbrick.sensors = [];
    for (var i = 0; i < sensor_ports.length; ++i) {
        if (sensor_ports[i].constructor.name === "AnalogPort")
            newbrick.sensors[i] = brick.sensor("A" + sensor_ports[i].value0);
        else
            newbrick.sensors[i] = brick.sensor("D" + sensor_ports[i].value0);
        newbrick.sensors[i].value0 = sensor_ports[i];
    }
    newbrick.orig = brick;
    return newbrick;
}

exports.brickSayUncurried = function(defbrick, string) {
    defbrick.orig.say(string);
}

exports.playSoundUncurried = function(defbrick, filename) {
    defbrick.orig.playSound(filename);
}

exports.brickStop = function(defbrick) {
    redefbrick.orig.stop();
}
