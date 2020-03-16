package robotModel.calibrate;

import trik.Brick;


class Main {
    public static function main() {
        Brick.gyroscope.calibrate(Seconds(15));
    }
}