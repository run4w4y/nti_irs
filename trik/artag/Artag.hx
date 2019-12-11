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
import trik.exceptions.ArtagException;
import Math.*;

using trik.tools.ImageTools;
using trik.tools.GeometryTools;


typedef Cells = Array<Array<Corners>>;

class Artag {
    public var image:Image<BinaryColor>;
    var corners:Corners;
    var markerSize:Int;
    public var marker:Image<BinaryColor>;

    function pixelToPoint(pixel:Pixel):Point {
        return new Point(
            pixel.x,
            -pixel.y
        );
    }

    @:generic
    function pointToPixel<T:PointLike>(pointLike:T):Pixel {
        return new Pixel(
            round(pointLike.x), 
            -round(pointLike.y)
        );
    }

    @:generic
    function invY<T:PointLike>(pointLike:T):T {
        pointLike.y *= -1;
        return pointLike;
    }

    function pixelDist(pixel1:Pixel, pixel2:Pixel):Float {
        return pixelToPoint(pixel1).distTo(pixelToPoint(pixel2));
    }

    @:generic
    function filter<C:Color>(image:Image<C>):Image<BinaryColor> {
        return image.toBinary(100).erode();
    }

    public function getCells():Cells {
        var res:Cells = [];
        var w = image[0].length, h = image.length;
        
        var leftLine = new Line(
            pixelToPoint(corners.leftTop), 
            pixelToPoint(corners.leftBottom)
        );
        var rightLine = new Line(
            pixelToPoint(corners.rightTop), 
            pixelToPoint(corners.rightBottom)
        );
        var topLine = new Line(
            pixelToPoint(corners.leftTop), 
            pixelToPoint(corners.rightTop)
        );
        var bottomLine = new Line(
            pixelToPoint(corners.leftBottom), 
            pixelToPoint(corners.rightBottom)
        );

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
                invY(leftLine.getPointY(corners.leftTop.y + leftDist * i / markerSize)),
                invY(rightLine.getPointY(corners.rightTop.y + rightDist * i / markerSize))
            ));
        }

        for (i in 0...markerSize) {
            var tmp:Array<Corners> = [];
            for (j in 0...markerSize) {
                tmp.push(new Corners(
                    pointToPixel(verticalLines[j].getIntersectionPoint(horizontalLines[i])),
                    pointToPixel(verticalLines[j + 1].getIntersectionPoint(horizontalLines[i])),
                    pointToPixel(verticalLines[j + 1].getIntersectionPoint(horizontalLines[i + 1])),
                    pointToPixel(verticalLines[j].getIntersectionPoint(horizontalLines[i + 1]))
                ));
            }
            res.push(tmp);
        }

        return res;
    }

    function getCellColor(cell:Corners):BinaryColor {
        var line1 = new Line(
            pixelToPoint(cell.leftTop),
            pixelToPoint(cell.rightBottom)
        );
        var line2 = new Line(
            pixelToPoint(cell.rightTop),
            pixelToPoint(cell.leftBottom)
        );
        var intersection:Pixel = pointToPixel(line1.getIntersectionPoint(line2));
        return image[intersection.y][intersection.x];
    }

    function checkMarker():Bool {
        for (i in 0...markerSize)
            if (
                marker[0][i].value ||
                marker[markerSize][i].value ||
                marker[i][0].value ||
                marker[i][markerSize].value
            ) return false;

        return true;
    }

    @:generic
    public function new<C:Color>( image:Image<C>, ?markerSize:Int = 6 ) {
        this.markerSize = markerSize;
        this.image = filter(image);
        this.corners = this.image.findCorners();
        this.marker = new Image<BinaryColor>(getCells().map(function(a) return a.map(getCellColor)));
        if (!checkMarker())
            throw new ArtagException('Could not read marker properly');
    }

    // public function read():ArtagValues {
    //     return new ArtagValues();
    // }
}