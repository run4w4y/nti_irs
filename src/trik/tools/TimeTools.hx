package src.trik.tools;

import src.trik.time.Time;
import Math.*;


class TimeTools {
    public static function toMilliseconds(time:Time):Time {
        switch (time) {
            case Milliseconds(_):
                return time;
            case Seconds(value):
                return Milliseconds(round(value*1000));
            case Minutes(value):
                return Milliseconds(round(60000*value));
        }
    }

    public static function toSeconds(time:Time):Time {
        switch (time) {
            case Milliseconds(value):
                return Seconds(value/1000);
            case Seconds(_):
                return time;
            case Minutes(value):
                return Seconds(value*60);
        }
    }

    public static function toMinutes(time:Time):Time {
        switch (time) {
            case Milliseconds(value):
                return Minutes(value/60000);
            case Seconds(value):
                return Minutes(value/60);
            case Minutes(_):
                return time;
        }
    }
}