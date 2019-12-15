package src.trik.robot.display;

import src.trik.robot.display.Pixel;


class Line {
    public var first:Pixel;
    public var second:Pixel;

    public function new(first:Pixel, second:Pixel) {
        this.first = first;
        this.second = second;
    }
}