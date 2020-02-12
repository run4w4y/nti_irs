package science.matrix;

import science.matrix.Matrix;
import range.Range;

using science.ScientificTools;


class MatrixTools {
    public static function rotateRight<T>(m:Matrix<T>):Matrix<T> {
		var res = new Matrix<T>();

		for (i in new Range(m[0].length - 1, -1)) {
			var tmp:Array<T> = [];
			for (j in 0...m.length)
				tmp.push(m[j][i]);
			res.push(tmp);
		}

		return res;
	}

	public static function rotateLeft<T>(m:Matrix<T>):Matrix<T> {
		var res = new Matrix<T>();

		for (i in 0...m[0].length) {
            var tmp:Array<T> = [];
            for (j in new Range(m.length - 1, -1))
                tmp.push(m[j][i]);
            res.push(tmp);
        }

        return res;
	}

    public static inline function submatrix<T>(m:Matrix<T>, x0:Int, y0:Int, x1:Int, y1:Int):Matrix<T> {
        return m.slice_(y0, y1).map(function (a) return a.slice_(x0, x1));
    }

    public static function flatten<T>(m:Matrix<T>):Array<T> {
        var res = [];

        for (i in m)
            res = res.concat(i);
        
        return res;
    }
}