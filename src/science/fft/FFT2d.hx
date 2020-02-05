package science.fft;

import science.complex.Complex;
import science.fft.FFT;
import science.Matrix;

using science.ScientificTools;


typedef ComplexMatrix = Matrix<Complex>;


class FFT2d {
    public static function fft(amplitudes:ComplexMatrix):ComplexMatrix {
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

	public static function ifft(amplitudes:ComplexMatrix):ComplexMatrix {
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

	public static function rfft<T:Float>(amplitudes:Matrix<T>):ComplexMatrix {
		return fft([for (i in amplitudes) i.map(function (a) return Complex.fromNumber(a))]);
	}

	public static function irfft<T:Float>(amplitudes:Matrix<T>):ComplexMatrix {
		return ifft([for (i in amplitudes) i.map(function (a) return Complex.fromNumber(a))]);
	}
}