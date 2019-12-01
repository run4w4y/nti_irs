package trik.robot;

import trik.robot.display.DisplayHigher;
import trik.robot.accelerometer.Accelerometer;
import trik.robot.battery.Battery;
import trik.robot.colorSensor.ColorSensor;
import trik.robot.encoder.Encoder;
import trik.robot.gyroscope.GyroscopeHigher;
import trik.robot.keys.KeysHigher;
import trik.robot.led.Led;
import trik.robot.lineSensor.LineSensor;
import trik.robot.motor.Motor;
import trik.robot.objectSensor.ObjectSensor;
import trik.robot.sensor.Sensor;

import trik.color.RGBColor;
import trik.image.RawImage;
import trik.image.Image;


class Brick {
    public var accelerometer :Accelerometer;
    public var battery       :Battery;
    public var display       :DisplayHigher;
    public var keys          :KeysHigher;
    public var led           :Led;
    public var gyroscope     :GyroscopeHigher;
    
    public function encoder(port:String):Encoder {
        return untyped __js__("brick.encoder({0})", port);
    }

    public function motor(port:String):Motor {
        return untyped __js__("brick.motor({0})", port);
    }

    public function colorSensor(port:String):ColorSensor {
        return untyped __js__("brick.colorSensor({0})", port);
    }

    public function playSound(filename:String):Void {
        untyped __js__("brick.playSound({0})", filename);
    }

    public function say(phrase:String):Void {
        untyped __js__("brick.say({0})", phrase);
    }

    public function sensor(port:String):Sensor {
        return untyped __js__("brick.sensor({0})", port);
    }

    public function stop():Void {
        untyped __js__("brick.stop()");
    }

    public function objectSensor(port:String):ObjectSensor {
        return untyped __js__("brick.objectSensor({0})", port);
    }

    function getRawPhoto():RawImage {
        return new RawImage(untyped __js__("getPhoto()"));
    }

    public function getPhoto():Image<RGBColor> {
        return getRawPhoto().toImage();
    }

    // TODO: complete
    // public function getStillImage():

    public function new():Void {
        this.accelerometer = untyped __js__("brick.accelerometer()");
        this.battery = untyped __js__("brick.battery()");
        this.display = new DisplayHigher();
        this.keys = new KeysHigher();
        this.led = untyped __js__("brick.led()");
        this.gyroscope = new GyroscopeHigher();
    }
}