package robotModel.motor;

import trik.Brick;
import trik.robot.motor.Motor as MotorRaw;
import robotModel.motor.Encoder;
import robotModel.motor.exceptions.PortException;


class Motor {
    public var encoder:Encoder;
    var innerMotor:MotorRaw;
    var inversed:Bool;

    public function new(port:String, encoder:Encoder, ?inversed = false) {
        this.encoder = encoder;
        innerMotor = Brick.motor(port);

        if (innerMotor == null)
            throw new PortException('No motor was found on the port $port');
        
        this.inversed = inversed;
    }

    public function setPower(power:Int):Void {
        innerMotor.setPower(if (inversed) -power else power);
    }

    public function stop():Void {
        innerMotor.powerOff();
    }
}