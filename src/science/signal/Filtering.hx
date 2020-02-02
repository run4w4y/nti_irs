package science.signal;

import exceptions.ValueException;

using science.ScientificTools;


class Filtering {
    public static function medianFilter1d<T:Float>(values:Array<T>, ?windowSize:Int=7):Array<Float> {
        if (windowSize % 2 == 0)
            throw new ValueException('windowSize argument in the medianFilter function call must be odd');
        
        return [for (i in 0...values.length) values.getWindow(i, windowSize).median1d()];
    }
}