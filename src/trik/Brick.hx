package trik;

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

import color.RGBColor;
import image.RawImage;
import image.Image;


class Brick {
    public static var accelerometer:Accelerometer = untyped __js__("brick.accelerometer()");
    public static var battery:Battery = untyped __js__("brick.battery()");
    public static var display = new DisplayHigher();
    public static var keys = new KeysHigher();
    public static var led:Led = untyped __js__("brick.led()");
    public static var gyroscope = new GyroscopeHigher();
    
    public static function encoder(port:String):Encoder {
        return untyped __js__("brick.encoder({0})", port);
    }

    public static function motor(port:String):Motor {
        return untyped __js__("brick.motor({0})", port);
    }

    public static function colorSensor(port:String):ColorSensor {
        return untyped __js__("brick.colorSensor({0})", port);
    }

    public static function playSound(filename:String):Void {
        untyped __js__("brick.playSound({0})", filename);
    }

    public static function say(phrase:String):Void {
        untyped __js__("brick.say({0})", phrase);
    }

    public static function sensor(port:String):Sensor {
        return untyped __js__("brick.sensor({0})", port);
    }

    public static function stop():Void {
        untyped __js__("brick.stop()");
    }

    public static function objectSensor(port:String):ObjectSensor {
        return untyped __js__("brick.objectSensor({0})", port);
    }

    public static function getRawPhoto():RawImage {
        return new RawImage(untyped __js__("getPhoto()"));
    }

    public static function getPhoto():Image<RGBColor> {
        return getRawPhoto().toImage();
    }

    public static function playTone(frequency:Int, duration:Int):Void {
        untyped __js__("brick.playTone({0}, {1})", frequency, duration);
    }

    // TODO: complete
    // public function getStillImage():
}