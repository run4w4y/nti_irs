// import trik.Trik.*;
// import trik.robotModel.Environment;
// import trik.geometry.Point;
// import trik.geometry.Vector;
// import trik.geometry.Line;
// import trik.Trik.*;
import trik.color.Color;
import trik.color.RGBColor;
import trik.color.HSVColor;
import trik.color.MonoColor;
import trik.color.BinaryColor;
import trik.color.LiteralColors.*;
import trik.tools.ColorTools.*;
import trik.image.Image;
import trik.tools.ImageTools.*;
import trik.artag.Artag;
import json2object.JsonParser;
import json2object.JsonWriter;

import trik.geometry.Line;
import trik.geometry.Point;

using trik.tools.GeometryTools;
using Lambda;


class Main {
    public static function main():Void {
        // var model = new FinalModel({
        //     leftMotor:    brick.motor("M4"),
        //     rightMotor:   brick.motor("M3"),
        //     leftEncoder:  brick.encoder("E4"),
        //     rightEncoder: brick.encoder("E3"), 
        //     frontSensor:  brick.sensor("D1"),
        //     leftSensor:   brick.sensor("D2"),
        //     environment:  Simulator
        // });
        // model.solution();

        // var line1 = new Line(new Point(18, 0), new Point(0, -127));
        // var line2 = new Line(new Point(0, -21.25), new Point(116.67, -22.11));
        // trace(line1.getIntersectionPoint(line2));
        
        var parser = new JsonParser<Array<Array<Array<Int>>>>();
        var pixels:Array<Array<RGBColor>> = parser.fromJson(sys.io.File.read("tests/image.json").readLine(), "errors.txt").map(
            function(array:Array<Array<Int>>) return array.map(
                function (triple:Array<Int>) return new RGBColor(triple[0], triple[1], triple[2])
            )
        );
        var artag = new Artag(new Image<RGBColor>(pixels));
        var writer = new JsonWriter<Array<Array<Int>>>();
        sys.io.File.write("tests/image_res.json").writeString(
            writer.write(artag.image.map(
                function(array:Array<BinaryColor>) return array.map(
                    function(color:BinaryColor) return toMono(color).value
                )
            ))
        );
        trace(artag.marker.map(function(a) return a.map(
            function(c) return if (c.value) 'True' else 'False' 
        )));
        // trace(artag.getCells());
    }
}