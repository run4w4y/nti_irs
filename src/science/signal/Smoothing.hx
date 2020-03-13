package science.signal;

import exceptions.ValueException;
import science.signal.windows.WindowType;
import science.signal.windows.Windows;
import science.signal.convolve.Convolution;
import science.signal.convolve.ConvolutionType;

using science.ScientificTools;
using tools.NullTools;


class Smoothing {
    public static function smooth<T:Float>(
        values:Array<T>, 
        ?windowSize:Int=11, 
        ?windowType:WindowType
    ):Array<Float> {
        if (windowSize % 2 == 0)
            throw new ValueException('windowSize must be odd (got: $windowSize)');

        var window = Windows.getWindow(windowSize, windowType.coalesce(Blackman));
        var s = values.slice_(windowSize - 1, 0, -1).concat(
            values
        ).concat(
            values.slice_(-2, -windowSize - 1, -1)
        );

        return Convolution.convolve1d(s, [for (i in window) i / window.sum()], Valid).slice(0, -windowSize + 1);
    }
}