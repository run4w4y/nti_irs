'use strict';

exports.readAccelerometer = function() {
    return brick.accelerometer().read();
}