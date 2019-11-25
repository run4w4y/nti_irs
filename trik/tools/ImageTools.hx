package trik.tools;

import trik.image.Image;
import trik.image.Pixel;
import trik.image.Corners;
import trik.image.Sides;
import trik.color.Color;
import trik.color.ColorType;
import trik.range.Range;
import trik.ordering.Ordering;
import Math.*;

using trik.tools.ColorTools;
using Lambda;


class ImageTools {
    public static function toGreyscale(image:Image):Image {
        return new Image([
            for (i in image) [
                for (j in i) 
                    j.convert(MonoType)
            ]
        ]);
    }

    public static function findDarkestColor(image:Image):Color {
        var darkestColor:Color = Mono(255);
        for (i in image)
            for (j in i)
                if (j.convert(MonoType).getValue() < darkestColor.convert(MonoType).getValue())
                    darkestColor = j;
        return darkestColor.convert(image[0][0].getColorType());
    }

    public static function toBinary(image:Image, ?threshold:Int=20):Image {
        var darkestColor:Color = findDarkestColor(image);
        return new Image([
            for (i in image) [
                for (j in i)
                    if (abs(j.convert(MonoType).getValue() - darkestColor.convert(MonoType).getValue()) <= threshold) 
                        Black 
                    else 
                        White
            ]
        ]);
    }

    public static function crop(image:Image, sides:Sides):Image {
        return new Image(image.slice(sides.top, image.length - sides.bottom).map(
            function(i) return i.slice(sides.left, i.length - sides.right)
        ));
    }

    public static function findCorners(image:Image, ?color:Color):Corners {
        color = if (color != null) color else Black; 

        var res:Corners = {
            leftTop: null,
            rightTop: null,
            rightBottom: null,
            leftBottom: null
        };
        var width = image.length, height = image[0].length;

        // left top
        for (k in 0...width) {
            var i = 0, j = k;

            while (i < height && j >= 0) {
                if (image[i][j].compare(color)) {
                    res.leftTop = {x: i, y: j};
                    break;
                }

                ++i;
                --j;
            }

            if (res.leftTop != null) break;
        }

        // right top
        for (k in new Range(width - 1, -1)) {
            var i = 0, j = k;

            while (i < height && j < width) {
                if (image[i][j].compare(color)) {
                    res.rightTop = {x: i, y: j};
                    break;
                }

                ++i;
                ++j;
            }

            if (res.rightTop != null) break;
        }

        // right bottom
        for (k in new Range(width - 1, -1)) {
            var i = height - 1, j = k;

            while (i >= 0 && j < width) {
                if (image[i][j].compare(color)) {
                    res.rightBottom = {x: i, y: j};
                    break;
                }

                --i;
                ++j;
            }

            if (res.rightBottom != null) break;
        }

        // left bottom
        for (k in 0...width) {
            var i = height - 1, j = k;

            while (i >= 0 && j >= 0) {
                if (image[i][j].compare(color)) {
                    res.leftBottom = {x: i, y: j};
                    break;
                }

                --i;
                --j;
            }

            if (res.leftBottom != null) break;
        }

        return res;
    }

    public static function inverse(image:Image):Image {
        return new Image([
            for (i in image) [
                for (j in i) if (j == Black) White else Black
            ]
        ]);
    }

    public static function erode(image:Image, ?repeat:Int=1):Image {
        if (repeat < 0)
            throw "repeat value cant be lower than 0";
        if (repeat == 0) return image;

        var width = image.length, height = image[0].length;
        var res:Array<Array<Color>> = [];

        for (i in 0...width) {
            var newLine:Array<Color> = [];
            for (j in 0...height) {
                var localMax = Mono(0);
                for (ii in (i-1)...(i+2))
                    for (jj in (j-1)...(j+2))
                        if (ii >= 0 && jj >= 0 && ii < height && jj < width && 
                        image[ii][jj].compareMono(localMax) == GT) 
                            localMax = image[ii][jj];
                newLine.push(localMax);
            }
            res.push(newLine);
        }

        return erode(new Image(res), repeat - 1);
    }

    public static function downscale(image:Image, ?squareSize:Int=2, ?repeat:Int=1):Image {
        if (repeat < 0)
            throw "repeat value cant be less than 0";
        if (squareSize < 2)
            throw "squareSize value cant be less than 2";
        if (repeat == 0) return image;

        var width = image.length, height = image[0].length;
        var res:Array<Array<Color>> = [];

        for (i in new Range(0, height, squareSize)) {
            var newLine:Array<Color> = [];
            for (j in new Range(0, width, squareSize)) {
                var blackCount:Int = 0;
                for (ii in i...(i + squareSize)) 
                    for (jj in j...(j + squareSize)) 
                        if (image[ii][jj] == Black) ++blackCount;
                newLine.push(if (blackCount >= pow(squareSize, 2)/2) Black else White);
            }
            res.push(newLine);
        }

        return downscale(new Image(res), squareSize, repeat - 1);
    }
}