package src.app.main;

// import src.trik.src.trik.*;
// import src.trik.robotModel.Environment;
// import src.trik.geometry.Point;
// import src.trik.geometry.Vector;
// import src.trik.geometry.Line;
// import src.trik.src.trik.*;
import src.trik.color.Color;
import src.trik.color.RGBColor;
import src.trik.color.HSVColor;
import src.trik.color.MonoColor;
import src.trik.color.BinaryColor;
import src.trik.color.LiteralColors.*;
import src.trik.tools.ColorTools.*;
import src.trik.image.Image;
import src.trik.tools.ImageTools.*;
import src.trik.artag.Artag;
import json2object.JsonParser;
import json2object.JsonWriter;

import src.trik.geometry.Line;
import src.trik.geometry.Point;

using src.trik.tools.GeometryTools;
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