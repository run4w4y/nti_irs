package robotModel.motor;

import trik.Brick;
import trik.robot.encoder.Encoder as EncoderRaw;
import robotModel.motor.exceptions.PortException;


class Encoder {
    var innerEncoder:EncoderRaw;
    var inversed:Bool;

    public function new(port:String, ?inversed = false) {
        innerEncoder = Brick.encoder(port);

        if (innerEncoder == null)
            throw new PortException('No encoder was found on the port $port');
        
        this.inversed = inversed;
    }

    @:updateFrequency(5)
    public function read():Int {
        return if (inversed) innerEncoder.read() else -innerEncoder.read();
    }

    public inline function reset():Void {
        innerEncoder.reset();
    }
}