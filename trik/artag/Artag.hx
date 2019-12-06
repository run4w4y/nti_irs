package trik.artag;

import trik.image.Image;
import trik.image.Corners;
import trik.image.Sides;
import trik.image.Pixel;
import trik.artag.ArtagValues;
import trik.color.Color;
import trik.color.BinaryColor;
import trik.geometry.Line;
import trik.geometry.Point;
import trik.geometry.Vector;
import trik.geometry.PointLike;
import Math.*;

using trik.tools.ImageTools;
using trik.tools.GeometryTools;


class Artag {
    var image:Image<BinaryColor>;
    var corners:Corners;
    var markerSize:Int;

    function pixelToPoint(pixel:Pixel):Point {
        return new Point(
            pixel.x,
            pixel.y
        );
    }

    @:generic
    function pointToPixel<T:PointLike>(pointLike:T):Pixel {
        return new Pixel(
            round(pointLike.x), 
            round(pointLike.y)
        );
    }

    function pixelDist(pixel1:Pixel, pixel2:Pixel):Float {
        return pixelToPoint(pixel1).distTo(pixelToPoint(pixel2));
    }

    @:generic
    function filter<C:Color>(image:Image<C>):Image<BinaryColor> {
        return image.toBinary().erode();
    }

    function getCells():Array<Array<Corners>> {
        var res:Array<Array<Corners>> = [];
        
        var leftLine = new Line(corners.leftTop, corners.leftBottom);
        var rightLine = new Line(corners.rightTop, corners.rightBottom);
        var topLine = new Line(corners.leftTop, corners.rightTop);
        var bottomLine = new Line(corners.leftBottom, corners.rightBottom);

        var leftDist = pixelDist(corners.leftBottom, corners.leftTop);
        var rightDist = pixelDist(corners.rightBottom, corners.rightTop);
        var topDist = pixelDist(corners.leftTop, corners.rightTop);
        var bottomDist = pixelDist(corners.leftBottom, corners.rightBottom);

        var verticalLines:Array<Line> = [];
        var horizontalLines:Array<Line> = [];

        for (i in 0...markerSize + 1) {
            verticalLines.push(new Line(
                topLine.getPointX(corners.leftTop.x + topDist * i / markerSize),
                bottomLine.getPointX(corners.leftBottom.x + bottomDist * i / markerSize)
            ));
            horizontalLines.push(new Line(
                leftLine.getPointY(corners.leftTop.y + leftDist * i / markerSize),
                rightLine.getPointY(corners.rightTop.y + rightDist * i / markerSize)
            ));
        }

        for (i in 0...markerSize) {
            var tmp:Array<Corners> = [];
            for (j in 0...markerSize)
                tmp.push(new Corners(
                    pointToPixel(verticalLines[j].getIntersectionPoint(horizontalLines[i])),
                    pointToPixel(verticalLines[j].getIntersectionPoint(horizontalLines[i + 1])),
                    pointToPixel(verticalLines[j + 1].getIntersectionPoint(horizontalLines[i])),
                    pointToPixel(verticalLines[j + 1].getIntersectionPoint(horizontalLines[i + 1]))
                ));
            res.push(tmp);
        }

        return res;
    }

    @:generic
    public function new<C:Color>( image:Image<C>, ?markerSize:Int = 6 ) {
        this.markerSize = markerSize;
        this.image = filter(image);
        this.corners = this.image.findCorners();
    }

    // public function read():ArtagValues {
    //     return new ArtagValues();
    // }
}