package artag;

import image.Image;
import image.Corners;
import image.Sides;
import image.Pixel;
import color.Color;
import color.BinaryColor;
import science.geometry.Line;
import science.geometry.Point;
import science.geometry.Vector;
import science.matrix.Matrix;
import artag.exceptions.ArtagException;
import Math.*;

using tools.ImageTools;
using tools.GeometryTools;
using science.matrix.MatrixTools;


typedef Cells = Matrix<Corners>;

/**
    Class for reading artag markers from pictures. Note: to decode the marker use ArtagDecoder class.
**/
class Artag {
    // this var is public for debug/testing purposes
    @:dox(hide) public var image:Image<BinaryColor>;
    /**
        Field for storing corners found on the image.
    **/
    public var corners:Corners;
    var markerSize:Int;
    /**
        Marker read from the image.
    **/
    public var marker:Image<BinaryColor>;
    // the following vars are public for debug/testing purposes
    @:dox(hide) public var leftLine:Line;
    @:dox(hide) public var rightLine:Line;
    @:dox(hide) public var topLine:Line;
    @:dox(hide) public var bottomLine:Line;
    @:dox(hide) public var verticalLines:Array<Line>;
    @:dox(hide) public var horizontalLines:Array<Line>;

    function invY<T:Float>(p:Point<T>):Point<T> {
        return new Point<T>(p.x, -p.y);
    }

    function filter<C:Color>(image:Image<C>):Image<BinaryColor> {
        return image.toBinary(20).erode();
    }

    // the following function is public for debug purposes as well
    @:dox(hide)
    public function getCells():Cells {
        var res:Cells = [];
        
        leftLine = new Line(invY(corners.leftTop), invY(corners.leftBottom));
        rightLine = new Line(invY(corners.rightTop), invY(corners.rightBottom));
        topLine = new Line(invY(corners.leftTop), invY(corners.rightTop));
        bottomLine = new Line(invY(corners.leftBottom), invY(corners.rightBottom));

        var leftDist = corners.leftBottom.distTo(corners.leftTop);
        var rightDist = corners.rightBottom.distTo(corners.rightTop);
        var topDist = corners.leftTop.distTo(corners.rightTop);
        var bottomDist = corners.leftBottom.distTo(corners.rightBottom);

        verticalLines = [];
        horizontalLines = [];

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
                    invY(verticalLines[j].getIntersectionPoint(horizontalLines[i])).round(),
                    invY(verticalLines[j + 1].getIntersectionPoint(horizontalLines[i])).round(),
                    invY(verticalLines[j + 1].getIntersectionPoint(horizontalLines[i + 1])).round(),
                    invY(verticalLines[j].getIntersectionPoint(horizontalLines[i + 1])).round()
                ));
            }
            res.push(tmp);
        }

        return res;
    }

    function getCellColor(cell:Corners):BinaryColor {
        var line1 = new Line(
            invY(cell.leftTop),
            invY(cell.rightBottom)
        );
        var line2 = new Line(
            invY(cell.rightTop),
            invY(cell.leftBottom)
        );
        var intersection:Pixel = invY(line1.getIntersectionPoint(line2)).round();
        return image[intersection.y][intersection.x];
    }

    function checkControlBit():Bool {
        return !marker[markerSize - 2][markerSize - 2].value;
    }

    /**
        Checks if the marker found on the image is valid.

        @returns true if marker is valid, false otherwise
    **/
    public function checkMarker():Bool {
        for (i in 0...markerSize)
            if (
                !marker[0][i].value ||
                !marker[markerSize - 1][i].value ||
                !marker[i][0].value ||
                !marker[i][markerSize - 1].value
            ) return false;

        return checkControlBit();
    }

    function rotateMarker():Void {
        var rotateCount = 0;
        while (!checkControlBit()) {
            marker = marker.rotateRight();
            ++rotateCount;
            if (rotateCount >= 4)
                throw new ArtagException('Could not find control bit in the given marker');
        }
    }

    /**
        Class constructor.

        @param image image from which artag marker need to be read
        @param checkFlag if true then ArtagException will be thrown in case marker isn't valid
        @param markerSize the expected size of marker on the image
        @throws ArtagException in case checkFlag is true and read marker was not valid
    **/
    public function new<C:Color>( image:Image<C>, ?checkFlag:Bool=true, ?markerSize:Int = 5 ) {
        this.markerSize = markerSize;
        this.image = filter(image);
        this.corners = this.image.findCorners();
        marker = new Image<BinaryColor>(getCells().map(function(a) return a.map(getCellColor)));
        rotateMarker();

        if (checkFlag && !checkMarker())
            throw new ArtagException('Could not read marker properly');
    }
}