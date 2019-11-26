package trik.artag;

import trik.image.Image;
import trik.image.Corners;
import trik.image.Sides;
import trik.image.Pixel;
import trik.artag.ArtagValues;

using trik.tools.ImageTools;


class Artag {
    var image:Image;

    function getROI():Image {
        var tmpImage:Image  = image.erode();
        var corners:Corners = tmpImage.findCorners();
        var sides:Sides     = tmpImage.cornersToSides(corners);
        var roiImage:Image  = tmpImage.cropSides(sides);
        var width = image[0].length, height = image.length;
        
        corners.leftTop.add(new Pixel(-15 + sides.left, -15 + sides.bottom, width, height));
        corners.rightTop.add(new Pixel(-15 + sides.left, 15 + sides.bottom, width, height));
        corners.rightBottom.add(new Pixel(15 + sides.left, 15 + sides.bottom, width, height));
        corners.leftBottom.add(new Pixel(15 + sides.left, -15 + sides.bottom, width, height));

        return image.cropCorners(corners);
    }

    public function new( ?image:Image ) {
        this.image = image;
    }

    // public function read():ArtagValues {
    //     return new ArtagValues();
    // }
}