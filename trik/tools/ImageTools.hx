package trik.tools;

import trik.image.Image;
import trik.color.Color;
import trik.color.ColorType in CT;
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

    public static function crop(image:Image, sides:{left:Int, top:Int, right:Int, bottom:Int}):Image {
        return new Image(image.slice(sides.top, image.length - sides.bottom).map(
            function(i) return i.slice(sides.left, i.length - sides.right)
        ));
    }
}