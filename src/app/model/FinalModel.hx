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

typedef FinalArguments = {
    > ModelArguments,
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
        var contents = str.split(' ');
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

        return if (first > 8) 
                {x: second, y: first - 8} 
            else 
                {x: first, y: second - 8};
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

    function goForth():Void {
        moveGyro(90, function () {
            return (leftEncoder.read() + rightEncoder.read()) / 2 <= 70;
        });
        stop(Seconds(0.1));
    }

    public function solution():Void {
        var dest = getDestination();
        var a = 0;
        var resX = -1;
        var resY = -1;

        for (i in 0...8) {
            var flag = false;
            for (j in 0...8) {
                var xCur = i;
                var yCur = j;
                var ok = true;
                var set = new HashSet<Pair<Direction, String>>();
                var dir = Right;
                var history:Array<Action> = [];

                for (step in 0...350) {
                    if (xCur < 0 || xCur >= 8 || yCur < 0 || xCur >= 8) {
                        ok = false;
                        break;
                    }
                    
                    var curPair = new Pair<Direction, String> (
                        dir,
                        Std.string(xCur) + Std.string(yCur) + '1'
                    );

                    if (!checkLeft() && !set.has(curPair)) {
                        set.add(curPair);
                        turn(-90);
                        goForth();
                        history.push(TurnLeft);
                        history.push(GoForth);

                        switch (dir) {
                            case Right: 
                                dir = Up;
                                --yCur;
                            case Up:
                                dir = Left;
                                --xCur;
                            case Left: 
                                dir = Down;
                                ++yCur;
                            case Down:
                                dir = Right;
                                ++xCur;
                        }

                        continue;
                    }

                    //

                    if (!checkFront() && !set.has(curPair)) {
                        set.add(curPair);
                        goForth();
                        history.push(GoForth);

                        switch (dir) {
                            case Right:
                                ++xCur;
                            case Up:
                                --yCur;
                            case Left:
                                --xCur;
                            case Down:
                                ++yCur;
                        }

                        continue;
                    }

                    //

                    if (!checkRight() && !set.has(curPair)) {
                        set.add(curPair);
                        turn(90);
                        goForth();
                        history.push(TurnRight);
                        history.push(GoForth);

                        switch (dir) {
                            case Right: 
                                dir = Down;
                                ++yCur;
                            case Up:
                                dir = Right;
                                ++xCur;
                            case Left: 
                                dir = Up;
                                --yCur;
                            case Down:
                                dir = Left;
                                --xCur;
                        }

                        continue;
                    }

                    turn(180);
                    history.push(TurnRight);
                    history.push(TurnRight);
                    switch (dir) {
                        case Right:
                            dir = Left;
                        case Left:
                            dir = Right;
                        case Up:
                            dir = Down;
                        case Down:
                            dir = Up;
                    }
                }

                turn(180);
                history.reverse();
                for (action in history) {
                    switch (action) {
                        case GoForth:
                            goForth();
                        case TurnRight:
                            turn(-90);
                        case TurnLeft:
                            turn(90);
                    }
                }


                if (ok) {
                    resX = i;
                    resY = j;
                    flag = true;
                    break;
                }
            }
            if (flag) break;
        }

        var xCur = resX;
        var yCur = resY;
        var set = new HashSet<Pair<Direction, String>>();
        var dir = Right;

        for (step in 0...350) {
            if (xCur == dest.x && yCur == dest.y) {
                brick.display.addLabel("finish", new Pixel(0, 0));
                return;
            }

            var curPair = new Pair<Direction, String> (
                dir,
                Std.string(xCur) + Std.string(yCur) + '1'
            );

            if (!checkLeft() && !set.has(curPair)) {
                set.add(curPair);
                turn(-90);
                goForth();

                switch (dir) {
                    case Right: 
                        dir = Up;
                        --yCur;
                    case Up:
                        dir = Left;
                        --xCur;
                    case Left: 
                        dir = Down;
                        ++yCur;
                    case Down:
                        dir = Right;
                        ++xCur;
                }

                continue;
            }

            //

            if (!checkFront() && !set.has(curPair)) {
                set.add(curPair);
                goForth();

                switch (dir) {
                    case Right:
                        ++xCur;
                    case Up:
                        --yCur;
                    case Left:
                        --xCur;
                    case Down:
                        ++yCur;
                }

                continue;
            }

            //

            if (!checkRight() && !set.has(curPair)) {
                set.add(curPair);
                turn(90);
                goForth();

                switch (dir) {
                    case Right: 
                        dir = Down;
                        ++yCur;
                    case Up:
                        dir = Right;
                        ++xCur;
                    case Left: 
                        dir = Up;
                        --yCur;
                    case Down:
                        dir = Left;
                        --xCur;
                }

                continue;
            }

            turn(180);
            switch (dir) {
                case Right:
                    dir = Left;
                case Left:
                    dir = Right;
                case Up:
                    dir = Down;
                case Down:
                    dir = Up;
            }
        }
    }
}