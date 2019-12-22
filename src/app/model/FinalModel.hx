package app.model;

import robotModel.RobotModel;
import robotModel.ModelArguments;
import trik.robot.sensor.Sensor;
import time.Time;
import trik.robot.display.Pixel;
import Math.*;
import trik.Trik.*;
import app.artagDecoder.ArtagDecoder;
import color.HexColor;
import color.RGBColor;
import image.Image;
import artag.Artag;
import pair.Pair;
import hashset.HashSet;

using tools.ColorTools;
using StringTools;


enum Direction {
    Up;
    Down;
    Left;
    Right;
}

enum Action {
    TurnLeft;
    TurnRight;
    GoForth;
}

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
        var lines = script.readAll('input.txt');
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
        goEnc(1385);
    }

    public function solution():Void {
        goEnc(150);
        var dest = getDestination();
        var a = 0;
        var resX = -1;
        var resY = -1;
        print('${dest.y} ${dest.x}');

        dfs(10, 10, Right);
        if (abs(10 -  minX) + maxX - 10 != 7 || abs(10 -  minY) + maxY - 10 != 7) 
            throw 'gavna';

        used = [for (i in 0...25) [for (j in 0...25) false]];
        resX = cast (abs(10 - minX), Int);
        resY = cast (abs(10 - minY), Int);
        dfs(resX, resY, Right, true, dest.x, dest.y);
    }

    var minX = 10;
    var maxX = 10;
    var minY = 10;
    var maxY = 10;
    var used:Array<Array<Bool>> = [for (i in 0...25) [for (j in 0...25) false]];

    function dfs(x:Int, y:Int, dir:Direction, ?flag:Bool=false, ?dx:Int, ?dy:Int):Void {
        if (flag && x == dx && y == dy) {
            brick.display.addLabel("finish", new Pixel(0, 0));
            throw 'gotovo epta';
            return;
        }
        
        minX = cast (min(minX, x), Int);
        maxX = cast (max(maxX, x), Int);
        minY = cast (min(minY, y), Int);
        maxY = cast (max(maxY, y), Int);
        var leftFree = false;
        var rightFree = false;
        var downFree = false;
        var upFree = false;
        used[x][y] = true;
        
        switch (dir) {
            case Up:
                upFree = !checkFront();
                leftFree = !checkLeft();
                rightFree = !checkRight();
            case Down:
                downFree = !checkFront();
                rightFree = !checkLeft();
                leftFree = !checkRight();
            case Right:
                rightFree = !checkFront();
                upFree = !checkLeft();
                downFree = !checkRight();
                if (x == 10 && y == 10) {
                    turn(-90);
                    leftFree = !checkRight();
                    turn(90);
                }
            case Left:
                leftFree = !checkFront();
                downFree = !checkLeft();
                upFree = !checkRight();
        }


        if (upFree && !used[x][y - 1]) {
            switch (dir) {
                case Up:
                    goForth();
                    dfs(x, y - 1, Up);
                    goForth();
                    turn(180);
                case Down:
                    turn(180);
                    goForth();
                    dfs(x, y - 1, Up);
                    goForth();
                    // turn(180);
                case Left:
                    turn(-90);
                    goForth();
                    dfs(x, y - 1, Up);
                    // turn(180);
                    goForth();
                    turn(-90);
                case Right:
                    turn(90);
                    goForth();
                    dfs(x, y - 1, Up);
                    // turn(180);
                    goForth();
                    turn(90);
            }
        }

        if (leftFree && !used[x - 1][y]) {
            switch (dir) {
                case Up:
                    turn(90);
                    goForth();
                    dfs(x - 1, y, Left);
                    // turn(180);
                    goForth();
                    turn(90);
                case Down:
                    turn(-90);
                    goForth();
                    dfs(x - 1, y, Left);
                    // turn(180);
                    goForth();
                    turn(-90);
                case Left:
                    goForth();
                    dfs(x - 1, y, Left);
                    goForth();
                    turn(180);
                case Right:
                    turn(180);
                    goForth();
                    dfs(x - 1, y, Left);
                    goForth();
                    // turn(180);
            }
        }  

        if (rightFree && !used[x + 1][y]) {
            switch (dir) {
                case Up:
                    turn(-90);
                    goForth();
                    dfs(x + 1, y, Right);
                    // turn(180);
                    goForth();
                    turn(-90);
                case Down:
                    turn(90);
                    goForth();
                    dfs(x + 1, y, Right);
                    // turn(180);
                    goForth();
                    turn(90);
                case Right:
                    goForth();
                    dfs(x + 1, y, Right);
                    goForth();
                    turn(180);
                case Left:
                    turn(180);
                    goForth();
                    dfs(x + 1, y, Right);
                    goForth();
                    // turn(180);
            }
        } 

        if (downFree && !used[x][y + 1]) {
            switch (dir) {
                case Up:
                    turn(180);
                    goForth();
                    dfs(x, y + 1, Down);
                    goForth();
                    // turn(180);
                case Down:
                    goForth();
                    dfs(x, y + 1, Down);
                    goForth();
                    turn(180);
                case Left:
                    turn(90);
                    goForth();
                    dfs(x, y + 1, Down);
                    // turn(180);
                    goForth();
                    turn(90);
                case Right:
                    turn(-90);
                    goForth();
                    dfs(x, y + 1, Down);
                    // turn(180);
                    goForth();
                    turn(-90);
            }
        }

        // if (!leftFree && !rightFree && !upFree && !downFree)
        turn(180);
    } 
}