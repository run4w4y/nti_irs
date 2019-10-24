'use strict';

exports.readAccelerometer = function(obj) {
    return obj.read();
}

exports.readSensor = function(obj) {
    return obj.read();
}

exports.getSensor = function(port) {
    switch (port) {
        case 0:
            return brick.accelerometer;
        case 1:
            return brick.gyroscope;
    }
}