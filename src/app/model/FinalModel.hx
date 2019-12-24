package app.model;

import robotModel.RobotModel;
import robotModel.ModelArguments;
import trik.Script;
import trik.Brick;
import trik.robot.sensor.Sensor;
import time.Time;
import trik.robot.display.Pixel;
import Math.*;
import app.artagDecoder.ArtagDecoder;
import color.HexColor;
import color.RGBColor;
import image.Image;
import artag.Artag;
import graph.Labyrinth;
import graph.Node;
import graph.Direction;
import graph.Movement;

using tools.ColorTools;
using StringTools;


typedef FinalArguments = ModelArguments & {
    frontSensor:Sensor,
    leftSensor:Sensor,
    rightSensor:Sensor
}

class FinalModel extends RobotModel {
    var frontSensor:Sensor;
    var leftSensor:Sensor;
    var rightSensor:Sensor;

    public function new(args:FinalArguments):Void {
        super(args);
        this.frontSensor = args.frontSensor;
        this.leftSensor  = args.leftSensor;
        this.rightSensor = args.rightSensor;
    }

    function moveWall(speed:Int=100, setpoint:Float, ?condition:(Void -> Bool), ?interval:Time):Void {
        move(speed, setpoint, function() {
                var readVal = leftSensor.read();
                return 
                    if (abs(readVal - setpoint) > 3) 
                        setpoint
                    else 
                        readVal;
            }, function(value, setpoint) {
                return setpoint - value;
            }, {kp: 0.5}, condition, interval
        );
    }

    function stringToImage(str:String):Image<RGBColor> {
        var w = 160;
        var h = 120;
        var contents = str.trim().split(' ');
        var res:Array<Array<RGBColor>> = [];

        for (i in 0...h) {
            var tmp:Array<RGBColor> = [];
            for (j in 0...w) {
                var curIndex = w * i + j;
                if (contents[curIndex] != null)
                    tmp.push(new HexColor(contents[curIndex]).toRGB()); 
            }
            res.push(tmp);
        }

        return new Image<RGBColor>(res);
    }

    function getDestination():{x:Int, y:Int} {
        var lines = Script.readAll('input.txt');
        var first = new ArtagDecoder(
            new Artag(stringToImage(lines[0]))
        ).read();
        var second = new ArtagDecoder(
            new Artag(stringToImage(lines[1]))
        ).read();

        return if (first < 8) 
                {x: first, y: second - 8} 
            else 
                {x: second, y: first - 8};
    }

    function checkLeft():Bool { // is there anything to the left
        return leftSensor.read() <= 50;
    }

    function checkRight():Bool { // is there anything to the right
        return rightSensor.read() <= 50;
    }

    function checkFront():Bool { // is there anything to the front
        return frontSensor.read() <= 50;
    }

    function goEnc(encValue:Int):Void {
        moveGyro(90, function () {
            return (leftEncoder.read() + rightEncoder.read()) / 2 <= encValue;
        });
        stop(Seconds(0.1));
    }

    function goForth():Void {
        goEnc(1360);
    }

    public function solution():Void {
        goEnc(150);
        var dest = getDestination();
        Script.print('${dest.x} ${dest.y}');
        var lab = new Labyrinth(8, 8);
        var startNode = lab.localizeUndefined(
            Right, 
            function() turn(90), 
            function() turn(-90),
            function() turn(180),
            goForth,
            checkLeft,
            checkRight,
            checkFront
        );
        var moves = lab.getPath(startNode,new Node(dest.y,dest.x));
        for (move in moves){
            switch(move){
                case Go:
                    goForth();
                case RotateLeft:
                    turn(90);
                case RotateRight:
                    turn(-90);
                case Undefined:
                    throw "can't reach destination point";
            }
        }
        Brick.display.addLabel('finish', new Pixel(0, 0));
    }
}