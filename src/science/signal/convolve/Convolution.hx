package science.signal.convolve;

import science.signal.convolve.ConvolutionType;
import exceptions.ValueException;

using tools.NullTools;


class Convolution {
    static function convolveFull<T:Float>(
        values:Array<T>,
        weights:Array<T>
    ):Array<Float> {
        var nconv = values.length + weights.length - 1;
        var res:Array<Float> = [];
    
        for (i in 0...nconv) {
            var i1 = i;
            var tmp = .0;
            for (j in 0...weights.length) {
                if (i1 >= 0 && i1 < values.length)
                    tmp += values[i1] * weights[j];
                --i1;
            }
            res.push(tmp);
        }

        return res;
    }

    public static function convolve1d<T:Float>(
        values:Array<T>, 
        weights:Array<T>, 
        ?mode:ConvolutionType
    ):Array<Float> {
        if (values.length == 0)
            throw new ValueException('values cant be empty');
        if (weights.length == 0)
            throw new ValueException('weights cant be empty');
        mode = mode.coalesce(Valid);
        var res = convolveFull(values, weights);
        switch (mode) {
            case Valid: 
                return res.slice(weights.length - 1, res.length - weights.length + 1);
            case Full: 
                return res;
            case Same:
                return res.slice(weights.length - 2, res.length - weights.length + 2);
        }
    }
}