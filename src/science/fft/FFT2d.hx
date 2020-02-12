package science.fft;

import science.complex.Complex;
import science.fft.FFT;
import science.matrix.Matrix;

using science.matrix.MatrixTools;


class FFT2d {
    public static function fft(amplitudes:Matrix<Complex>):Matrix<Complex> {
        if (amplitudes.length < 1 || amplitudes[0].length < 1)
			return [[]];

		var res =
			amplitudes
			.map(function (a) return FFT.fft(a))
			.rotateLeft()
			.map(function (a) return FFT.fft(a))
			.rotateRight();
		res.reverse();
		return res;
    }

	public static function ifft(amplitudes:Matrix<Complex>):Matrix<Complex> {
		if (amplitudes.length < 1 || amplitudes[0].length < 1)
			return [[]];
		
		amplitudes.reverse();
		var res =
			amplitudes
			.map(function (a) return FFT.ifft(a))
			.rotateLeft()
			.map(function (a) return FFT.ifft(a))
			.rotateRight();
		res.reverse();
		return res;
	}

	public static function rfft<T:Float>(amplitudes:Matrix<T>):Matrix<Complex> {
		return fft([for (i in amplitudes) i.map(function (a) return Complex.fromNumber(a))]);
	}

	public static function irfft<T:Float>(amplitudes:Matrix<T>):Matrix<Complex> {
		return ifft([for (i in amplitudes) i.map(function (a) return Complex.fromNumber(a))]);
	}
}