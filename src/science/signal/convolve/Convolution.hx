package science.signal.convolve;

import science.signal.convolve.ConvolutionType;
import exceptions.ValueException;

using tools.NullTools;


class Convolution {
    static function convolveValid<T:Float>(
        values:Array<T>, 
        weights:Array<T>
    ):Array<Float> {
        var nf = values.length;
        var ng = weights.length;
        var minV = if (nf < ng) values else weights;
        var maxV = if (nf < ng) weights else values;
        var n = cast(Math.max(nf, ng) - Math.min(nf, ng) + 1, Int);
        var res:Array<Float> = [];

        for (i in 0...n) {
            res.push(0);
            var k = i;
            for (j in new range.Range(minV.length - 1, 0, -1)) {
                res[i] += minV[j] * maxV[k];
                ++k;
            }
        }

        return res;
    }


    static function convolveFull<T:Float>(
        values:Array<T>,
        weights:Array<T>
    ):Array<Float> {
        var nf = values.length;
        var ng = weights.length;
        var n = nf + ng - 1;
        var res:Array<Float> = [];

        for (i in 0...n) {
            res.push(0);
            var jMin = if (i >= ng - 1) i - ng + 1 else 0;
            var jMax = if (i < nf - 1) i else nf - 1;

            for (j in jMin...jMax)
                res[i] += values[j] * weights[i - j];
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
        switch (mode) {
            case Valid: return convolveValid(values, weights);
            case Full: return convolveFull(values, weights);
        }
    }
}