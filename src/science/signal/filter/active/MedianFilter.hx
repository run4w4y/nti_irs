package science.signal.filter.active;

import exceptions.ValueException;

using science.ScientificTools;


class MedianFilter {
    var values:Array<Float> = [];
    var windowSize:Int;

    public function new<T:Float>(windowSize:Int) {
        if (windowSize % 2 == 0)
            throw new ValueException('median filter window size must be odd (got: $windowSize)');

        this.windowSize = windowSize;
    }

    public function add<T:Float>(value:T):Float {
        values.push(value);
        return try
            values.getWindow(-windowSize, windowSize).median1d()
        catch (_:ValueException) 
            value;
    }
}