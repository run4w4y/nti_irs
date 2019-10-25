'use strict';

exports.motorBrakeUncurried = function(motor, duration) {
    motor.brake(duration);
}

exports.getMotorPower = function(motor) {
    return motor.power();
}

exports.motorPowerOff = function(motor) {
    motor.powerOff();
}

exports.setMotorPowerUncurried = function(motor, power) {
    return function() {motor.setPower(power)};
}