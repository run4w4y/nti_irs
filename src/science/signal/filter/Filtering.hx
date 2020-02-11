package science.signal;

import exceptions.ValueException;
import science.Matrix;

using science.ScientificTools;


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
        
        return res;
    }
}