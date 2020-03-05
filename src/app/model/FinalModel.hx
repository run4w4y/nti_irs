package app.model;

import robotModel.RobotModel;
import robotModel.ModelArguments;
import trik.Script;
import trik.Brick;
import trik.robot.sensor.Sensor;
import time.Time;
import image.Pixel;
import Math.*;
import app.artagDecoder.ArtagDecoder;
import color.HexColor;
import color.RGBColor;
import image.Image;
import artag.Artag;
import graph.Labyrinth;
import graph.Node;
import graph.Direction;
import movementExecutor.Movement;
import movementExecutor.MovementExecutor;
import pid.PID;

using tools.ColorTools;
using tools.TimeTools;
using StringTools;

/**
    Type used for objects that are passed as arguments for the FinalModel class constructor. 
    Motors, sensor and all the other stuff must be passed like this.
**/
typedef FinalArguments = ModelArguments & {
    frontSensor:Sensor,
    leftSensor:Sensor,
    rightSensor:Sensor,
    cellSize:Float
}

/**
    Class for defining the robot model used in the task. All the stuff with sensors is done in here.
**/
class FinalModel extends RobotModel {
    var frontSensor :Sensor;
    var leftSensor  :Sensor;
    var rightSensor :Sensor;
    var cellSize    :Float;
    var frontDist   = 25;

    /**
        Class constructor. Takes an object defined by FinalArguments as its only argument.

        @param args object with arguments defined by FinalArguments type.
    **/
    public function new(args:FinalArguments):Void {
        super(args);
        this.frontSensor = args.frontSensor;
        this.leftSensor  = args.leftSensor;
        this.rightSensor = args.rightSensor;
        this.cellSize    = args.cellSize;
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
        return leftSensor.read() <= 70;
    }

    function checkRight():Bool { // is there anything to the right
        return rightSensor.read() <= 70;
    }

    function checkFront():Bool { // is there anything to the front
        return frontSensor.read() <= 70;
    }

    function align():Void {
        var readVal = frontSensor.read();
        var threshold = 25;
        var delta = readVal - frontDist;
        
        while (abs(delta) <= threshold && abs(delta) != 0) {
            readVal = frontSensor.read();
            delta = readVal - frontDist;
            var pid = new PID(Seconds(0.1), -100, 100, {kp: 10, kd: 0, ki: 0});
            var u = pid.calculate(delta);
            moveGyro(round(u));
            Script.wait(Seconds(0.1));
        }
        stop(Seconds(0.1));
    }

    function goEnc(encValue:Int):Void {
        var startTime = Script.time();
        moveGyro(90, function () {
            return (leftEncoder.read() + rightEncoder.read()) / 2 <= encValue && Script.time().getDifference(startTime) < 3000;
        });
        stop(Seconds(0.1));
    }


    /**
        Function in which the solution algorithm must be defined.
    **/
    public function solution():Void {
        goEnc(150);

        var cellEnc = round(cellSize / (wheelRadius * 2 * PI) * 360 / 10.45);
        var dest = getDestination();
        Script.print('${dest.x} ${dest.y}');
        var executor = new MovementExecutor(
            function (val:Int) { 
                turn(val); 
                align(); 
            },
            function () { 
                goEnc(cellEnc); 
                align(); 
            } 
        );
        
        var lab = new Labyrinth(8, 8);
        var startNode = lab.localizeUndefined(
            Right, 
            executor,
            checkLeft,
            checkRight,
            checkFront
        );

        for (move in lab.getPath(startNode, new Node(dest.y, dest.x)))
            executor.add(move);
        executor.execute();

        Brick.display.addLabel('finish', new Pixel(0, 0));
    }
}