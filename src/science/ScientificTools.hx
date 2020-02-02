package science;

import exceptions.ValueException;
import exceptions.IndexException;
import range.Range;


class ScientificTools {
    public static function maximum<T:Float>(values:Array<T>):T {
        var res = values[0];

        for (i in 1...values.length)
            if (values[i] > res) 
                res = values[i];

        return res;
    }

    public static function quickSelect<T:Float>(values:Array<T>, index:Int):Float {
        if (values.length == 1) {
            if (index != 0)
                throw new IndexException('index of selection is out of range');
            return values[0];
        }
        
        var pivot = Std.random(Math.ceil(maximum(values)));
        var lows = [for (i in values) if (i < pivot) i];
        var highs = [for (i in values) if (i > pivot) i];
        var pivots = [for (i in values) if (cast(i, Int) == pivot) i];

        if (index < lows.length)
            return quickSelect(lows, index);
        if (index < lows.length + pivots.length)
            return pivots[0];
        return quickSelect(highs, index - lows.length - pivots.length);
    }

    public static function median1d<T:Float>(values:Array<T>) {
        if (values.length % 2 == 1)
            return quickSelect(values, Math.ceil(values.length / 2) - 1);
        return 0.5 * (quickSelect(values, cast(values.length / 2, Int) - 1) + 
            quickSelect(values, cast(values.length / 2, Int)));
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

    public static function derivative<T1:Float, T2:Float>(func:T1 -> T2, x:T1, dx:T1):Float {
        var x1:T1 = x - dx;
        var x2:T1 = x + dx;
        var y1 = func(x1);
        var y2 = func(x2);
        return (y2 - y1) / (x2 - x1);
    }

    public static function rotateRight<T>(m:Array<Array<T>>):Array<Array<T>> {
		var res:Array<Array<T>> = [];

		for (i in new Range(m[0].length - 1, -1)) {
			var tmp:Array<T> = [];
			for (j in 0...m.length)
				tmp.push(m[j][i]);
			res.push(tmp);
		}

		return res;
	}

	public static function rotateLeft<T>(m:Array<Array<T>>):Array<Array<T>> {
		var res:Array<Array<T>> = [];

		for (i in 0...m[0].length) {
            var tmp:Array<T> = [];
            for (j in new Range(m.length - 1, -1))
                tmp.push(m[j][i]);
            res.push(tmp);
        }

        return res;
	}

    public static function round<T:Float>(value:T, ?precision:Int = 0):Float {
        return Math.round(value * Math.pow(10, precision)) / Math.pow(10, precision);
    }

    public static function getWindow<T>(values:Array<T>, startIndex:Int, windowSize:Int):Array<T> {
        if (startIndex < 0 || startIndex >= values.length)
            throw new IndexException('invalid index was passed to the getWindow function');
        
        return values.slice(startIndex, startIndex + windowSize).concat(
            if (startIndex + windowSize >= values.length) 
                values.slice(0, windowSize - values.length + startIndex)
            else 
                []
        );
    }
}