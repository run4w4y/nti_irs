package robotModel.calibrate;

import trik.Brick;
import trik.Script;


class Main {
    public static function main() {
        Brick.gyroscope.calibrate(Seconds(15));
        Script.wait(Seconds(15));
        Brick.say("oo");
    }
}