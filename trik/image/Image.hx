package trik.image;

import trik.color.Color;
import trik.color.ColorTools.*;


abstract Image(Array<Array<Color>>) {
    public function new(pixels:Array<Array<Color>>) {
        this = pixels;
    }
}