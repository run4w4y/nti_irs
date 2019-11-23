package trik.tools;

import trik.image.Image;
import trik.image.Pixel;
import trik.image.Corners;
import trik.image.Sides;
import trik.color.Color;
import trik.color.ColorType in CT;
import trik.range.Range;
import Math.*;

using trik.tools.ColorTools;
using Lambda;


class ImageTools {
    public static function toGreyscale(image:Image):Image {
        return new Image([
            for (i in 0...image.length) [
                for (j in 0...image[0].length) 
                    image[i][j].convert(CT.Mono)
            ]
        ]);
    }

    public static function findDarkestColor(image:Image):Color {
        var darkestColor:Color = Mono(255);
        for (i in image)
            for (j in i)
                if (j.convert(CT.Mono).getValue() < darkestColor.convert(CT.Mono).getValue())
                    darkestColor = j;
        return darkestColor.convert(image[0][0].getColorType());
    }

    public static function toBinary(image:Image, ?threshold:Int=20):Image {
        var greyImage:Image = toGreyscale(image);
        var darkestColor:Color = findDarkestColor(greyImage);
        return new Image([
            for (i in greyImage) [
                for (j in i)
                    if (abs(j.getValue() - darkestColor.getValue()) < threshold) 
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
}