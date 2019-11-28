package trik.tools;

import trik.image.Image;
import trik.image.Pixel;
import trik.image.Corners;
import trik.image.Sides;
import trik.color.Color;
import trik.color.RGBColor;
import trik.color.HSVColor;
import trik.color.MonoColor;
import trik.color.LiteralColors.*;
import trik.color.BinaryColor;
import trik.tools.ColorTools.*;
import trik.range.Range;
import trik.ordering.Ordering;
import Math.*;

using trik.tools.ColorTools;
using Lambda;


class ImageTools {
    @:generic
    public static function toGreyscale<C:Color>(image:Image<C>):Image<MonoColor> {
        return new Image<MonoColor>([
            for (i in image) [
                for (j in i) 
                    toMono(j)
            ]
        ]);
    }

    @:generic
    public static function findDarkestColor<C:Color>(image:Image<C>):C {
        var darkestColor = image[0][0];
        for (i in image)
            for (j in i)
                if (toMono(j).compareMono(toMono(darkestColor)) == LT)
                    darkestColor = j;
        return darkestColor;
    }

    @:generic
    public static function toBinary<C:Color>(image:Image<C>, ?threshold:Int=20):Image<BinaryColor> {
        var darkestColor = findDarkestColor(image);
        return new Image([
            for (i in image) [
                for (j in i)
                    if (abs(toMono(j).value - toMono(darkestColor).value) <= threshold) 
                        new BinaryColor(true)
                    else 
                        new BinaryColor(false)
            ]
        ]);
    }

    @:generic
    public static function cropSides<C:Color>(image:Image<C>, sides:Sides):Image<C> {
        return new Image<C>(image.slice(sides.top, image.length - sides.bottom).map(
            function(i) return i.slice(sides.left, i.length - sides.right)
        ));
    }

    @:generic
    public static function cornersToSides<C:Color>(image:Image<C>, corners:Corners):Sides {
        return {
            top:    round(min(corners.leftTop.y, corners.rightTop.y)),
            left:   round(min(corners.leftTop.x, corners.leftBottom.x)),
            right:  image[0].length    - round(max(corners.rightTop.x,   corners.rightBottom.x)),
            bottom: image.length - round(max(corners.leftBottom.y, corners.rightBottom.y))
        };
    }

    @:generic
    public static function cropCorners<C:Color>(image:Image<C>, corners:Corners):Image<C> {
        return cropSides(image, cornersToSides(image, corners));
    }

    @:generic
    public static function findCorners<C:Color>(image:Image<C>, ?color:C):Corners {
        var targetColor = if (color != null) color else new BinaryColor(true); 

        var res:Corners = new Corners();
        var width = image[0].length, height = image.length;

        // left top
        for (k in 0...width) {
            var i = 0, j = k;

            while (i < height && j >= 0) {
                if (compare(image[i][j], targetColor)) {
                    res.leftTop = new Pixel(j, i, width, height);
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
                if (compare(image[i][j], targetColor)) {
                    res.rightTop = new Pixel(j, i, width, height);
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
                if (compare(targetColor, image[i][j])) {
                    res.rightBottom = new Pixel(j, i, width, height);
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
                if (compare(image[i][j], targetColor)) {
                    res.leftBottom = new Pixel(j, i, width, height);
                    break;
                }

                --i;
                --j;
            }

            if (res.leftBottom != null) break;
        }

        return res;
    }

    public static function inverse(image:Image<BinaryColor>):Image<BinaryColor> {
        return new Image([
            for (i in image) [
                for (j in i) if (j.value) new BinaryColor(false) else new BinaryColor(true)
            ]
        ]);
    }

    public static function erode(image:Image<BinaryColor>, ?repeat:Int=1):Image<BinaryColor> {
        if (repeat < 0)
            throw "repeat value cant be lower than 0";
        if (repeat == 0) return image;

        var width = image[0].length, height = image.length;
        var res:Array<Array<BinaryColor>> = [];

        for (i in 0...width) {
            var newLine:Array<BinaryColor> = [];
            for (j in 0...height) {
                var localMax = new BinaryColor(false);
                for (ii in (i-1)...(i+2))
                    for (jj in (j-1)...(j+2))
                        if (ii >= 0 && jj >= 0 && ii < height && jj < width && 
                        image[ii][jj].value && !localMax.value)
                            localMax = image[ii][jj];
                newLine.push(localMax);
            }
            res.push(newLine);
        }

        return erode(new Image<BinaryColor>(res), repeat - 1);
    }

    public static function downscale(image:Image<BinaryColor>, ?squareSize:Int=2, ?repeat:Int=1):Image<BinaryColor> {
        if (repeat < 0)
            throw "repeat value cant be less than 0";
        if (squareSize < 2)
            throw "squareSize value cant be less than 2";
        if (repeat == 0) return image;

        var width = image[0].length, height = image.length;
        var res:Array<Array<BinaryColor>> = [];

        for (i in new Range(0, height, squareSize)) {
            var newLine:Array<BinaryColor> = [];
            for (j in new Range(0, width, squareSize)) {
                var blackCount:Int = 0;
                for (ii in i...(i + squareSize)) 
                    for (jj in j...(j + squareSize)) 
                        if (image[ii][jj].value) ++blackCount;
                newLine.push(if (blackCount >= pow(squareSize, 2)/2) new BinaryColor(true) else new BinaryColor(false));
            }
            res.push(newLine);
        }

        return downscale(new Image(res), squareSize, repeat - 1);
    }
}