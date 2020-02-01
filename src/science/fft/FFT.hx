package science.fft;

import science.complex.Complex;
import exceptions.ValueException;


class FFT {
    public static function fft(amplitudes:Array<Complex>):Array<Complex> {
        var n = amplitudes.length;

        if (n <= 1) return amplitudes;
        if (n % 2 != 0) throw new ValueException(
            'expected length of input array to be a power of 2, got $n'
        );

        var hn = cast(n/2, Int);
        var even = fft([for (i in 0...hn) amplitudes[i*2]]);
        var odd = fft([for (i in 0...hn) amplitudes[2*i + 1]]);

        var res = [for (_ in 0...n) new Complex(0, 0)];
        for (i in 0...hn) {
            var ith = -2 * i * Math.PI / n;
            var wk = new Complex(Math.cos(ith), Math.sin(ith));
            res[i] = even[i] + wk * odd[i];
            res[i + hn] = even[i] - wk * odd[i];
        }
        return res;
    }

    public static function ifft(amplitudes:Array<Complex>):Array<Complex> {
        var n = amplitudes.length;
        return [for (j in fft([for (i in 0...n) amplitudes[i].conjugate()])) j.conjugate() / n];
    }

    public static function rfft<T:Float>(amplitudes:Array<T>):Array<Complex> {
        return fft([for (i in amplitudes) Complex.fromNumber(i)]);
    }

    public static function irfft<T:Float>(amplitudes:Array<T>):Array<Complex> {
        return ifft([for (i in amplitudes) Complex.fromNumber(i)]);
    }
}