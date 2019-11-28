// import trik.robot.motor.Motor;
// import trik.Trik.*;
// import trik.color.Color;
// import trik.color.ColorTools.*;
// import trik.robot.keys.Key;
import trik.color.Color;
import trik.color.RGBColor;
import trik.color.HSVColor;
import trik.color.MonoColor;
import trik.color.BinaryColor;
import trik.color.LiteralColors.*;
import trik.tools.ColorTools.*;
import trik.image.Image;
import trik.tools.ImageTools.*;
import json2object.JsonParser;
import json2object.JsonWriter;
// import trik.artag.Artag;

using Lambda;
// using trik.tools.ImageTools;


class Main {
    public static function main() {
        var parser = new JsonParser<Array<Array<Array<Int>>>>();
        var pixels:Array<Array<RGBColor>> = parser.fromJson(sys.io.File.read("tests/image.json").readLine(), "errors.txt").map(
            function(array:Array<Array<Int>>) return array.map(
                function (triple:Array<Int>) return new RGBColor(triple[0], triple[1], triple[2])
            )
        );
        var image = new Image<RGBColor>(pixels);
        var writer = new JsonWriter<Array<Array<Int>>>();
        sys.io.File.write("tests/image_res.json").writeString(
            writer.write(downscale(toBinary(image, 100)).map(
                function(array:Array<BinaryColor>) return array.map(
                    function(color:BinaryColor) return toMono(color).value
                )
            ))
        );
    }
}