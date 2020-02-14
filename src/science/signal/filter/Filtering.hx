package science.signal.filter;

import exceptions.ValueException;
import science.matrix.Matrix;
import ds.Range;
import science.signal.convolve.Convolution;

using science.ScientificTools;
using science.matrix.MatrixTools;


class Filtering {
    public static function medianFilter1d<T:Float>(values:Array<T>, ?windowSize:Int=7):Array<Float> {
        if (windowSize % 2 == 0)
            throw new ValueException('windowSize argument in the medianFilter function call must be odd');
        if (windowSize > values.length)
            throw new ValueException('windowSize cant be bigger than length of values');

        return [for (i in 0...values.length) values.getWindow(i, windowSize).median1d()];
    }

    public static function medianFilter2d<T:Float>(values:Matrix<T>, ?windowSize:Int=7):Matrix<Float> {
        var res:Matrix<Float> = [];

        var wh:Int = Math.ceil(windowSize / 2) - 1;
        for (i in new Range(0, values.height).slice_(wh, -wh)) {
            var tmp:Array<Float> = [];
            for (j in new Range(0, values.width).slice_(wh, -wh))
                tmp.push(values.submatrix(j - wh, i - wh, j + wh + 1, i + wh + 1).median2d());
            res.push(tmp);
        }
        
        return res;
    }

    public static function movingAverage<T:Float>(values:Array<T>, ?windowSize:Int=3):Array<Float> {
        return Convolution.convolve1d(values, [for (_ in 0...windowSize) 1 / windowSize], Valid);
    }
}