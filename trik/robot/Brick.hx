package trik.robot;

import trik.robot.display.Display;
import trik.robot.accelerometer.Accelerometer;
import trik.robot.battery.Battery;
import trik.robot.colorSensor.ColorSensor;
import trik.robot.encoder.Encoder;
import trik.robot.gyroscope.Gyroscope;
import trik.robot.keys.Keys;
import trik.robot.led.Led;
import trik.robot.lineSensor.LineSensor;
import trik.robot.motor.Motor;


extern class ObjectSensor {
    public function new():Void;
    
    @:selfCall
    function call():Void;
}

extern class Sensor {
    public function new():Void;
    
    @:selfCall
    function call():Void;
}

class Brick {
    var accelerometer :Accelerometer;
    var battery       :Battery;
    var display       :Display;
    var keys          :Keys;
    var led           :Led;
    var gyroscope     :Gyroscope;
    var lineSensor    :LineSensor;
    var objectSensor  :ObjectSensor;
    
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

    // TODO: complete
    // public function getStillImage():

    public function new():Void {
        this.accelerometer = untyped __js__("brick.accelerometer()");
        this.battery = untyped __js__("brick.battery()");
        this.display = untyped __js__("brick.display()");
        this.keys = untyped __js__("brick.display()");
        this.led = untyped __js__("brick.led()");
        this.gyroscope = untyped __js__("brick.gyroscope()");
        this.objectSensor = untyped __js__("brick.objectSensor()");
    }
}