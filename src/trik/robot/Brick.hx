package src.trik.robot;

import src.trik.robot.display.DisplayHigher;
import src.trik.robot.accelerometer.Accelerometer;
import src.trik.robot.battery.Battery;
import src.trik.robot.colorSensor.ColorSensor;
import src.trik.robot.encoder.Encoder;
import src.trik.robot.gyroscope.GyroscopeHigher;
import src.trik.robot.keys.KeysHigher;
import src.trik.robot.led.Led;
import src.trik.robot.lineSensor.LineSensor;
import src.trik.robot.motor.Motor;
import src.trik.robot.objectSensor.ObjectSensor;
import src.trik.robot.sensor.Sensor;

import src.trik.color.RGBColor;
import src.trik.image.RawImage;
import src.trik.image.Image;


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