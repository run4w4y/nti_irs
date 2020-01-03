package tools;

import exceptions.ValueException;


class ScientificTools {
    public static function median1d<T:Float>(values:Array<T>) {
        values.sort(Reflect.compare);
        return values[Math.floor(values.length / 2)];
    }

    static function interpolateF<T:Float>(x:T, x1:T, y1:T, x2:T, y2:T):Float {
        return y1 + (y2 - y1) / (x2 - x1) * (x - x1);
    }

    public static function interpolate1d<T:Float>(xs:Array<T>, ys:Array<T>, ?fillValues:Bool=false):T -> Float {
        if (xs.length != ys.length)
            throw new ValueException('arrays xs and ys must be of the same length, but length of array xs is ${xs.length} and length of array ys is ${ys.length}');
        
        if (xs.length < 2)
            throw new ValueException('cant interpolate over array of length 1');
        
        xs.sort(Reflect.compare);
        ys.sort(Reflect.compare);
        return function(x) {
            if (x < xs[0] || x > xs[xs.length - 1])
                if (!fillValues)
                    throw new ValueException('x value ($x) is out of the interpolation range');
                else return
                    if (x < xs[0])
                        interpolateF(x, xs[1], ys[1], xs[0], ys[0])
                    else
                        interpolateF(x, xs[xs.length - 2], ys[ys.length - 2], xs[xs.length - 1], ys[ys.length - 1]);
            
            var x1 = -1;
            var x2 = -1;
            for (i in 0...xs.length) {
                if (xs[i] == x) {
                    return ys[i];
                } else if (xs[i] > x && i != 0) {
                    x1 = i - 1;
                    x2 = i;
                    break;
                }
            }

            if (x1 == -1)
                throw new ValueException('couldnt interpolate for the given x: $x');
            
            return interpolateF(x, xs[x1], ys[x1], xs[x2], ys[x2]);
        };
    }
}