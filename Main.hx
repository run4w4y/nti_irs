// import trik.robot.motor.Motor;
// import trik.Trik.*;
// import trik.color.Color;
// import trik.color.ColorTools.*;
// import trik.robot.keys.Key;
import trik.color.Color;
import trik.image.Image;
import json2object.JsonParser;
import json2object.JsonWriter;

using Lambda;
using trik.tools.ImageTools;
using trik.tools.ColorTools;


class Main {
    public static function main() {
        var parser = new JsonParser<Array<Array<Array<Int>>>>();
        var pixels:Array<Array<Color>> = parser.fromJson(sys.io.File.read("tests/image.json").readLine(), "errors.txt").map(
            function(array:Array<Array<Int>>) return array.map(
                function (triple:Array<Int>) return RGB(triple[0], triple[1], triple[2])
            )
        );
        var image = new Image(pixels);
        var writer = new JsonWriter<Array<Array<Int>>>();
        sys.io.File.write("tests/image_res.json").writeString(
            writer.write(image.toGreyscale().map(
                function(array:Array<Color>) return array.map(
                    function(color:Color) return color.getValue()
                )
            ))
        );
    }
}