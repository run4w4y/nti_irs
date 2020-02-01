package science.complex;

using science.ScientificTools;


abstract Complex(Array<Float>) to Array<Float> {
    public var realValue(get, set):Float;
    public var imagValue(get, set):Float;

    private function get_realValue():Float {
        return this[0];
    }

    private function get_imagValue():Float {
        return this[1];
    }

    private function set_realValue(value:Float):Float {
        this[0] = value;
        return this[0];
    }

    private function set_imagValue(value:Float):Float {
        this[1] = value;
        return this[1];
    }

    public function new(realValue:Float, ?imagValue:Float = 0):Void {
        this = new Array<Float>();
        this.push(realValue);
        this.push(imagValue);
    }

    @:from
    public static function fromArray(a:Array<Float>):Complex {
        return new Complex(a[0], a[1]);
    }

    public static function fromNumber<T:Float>(value:T):Complex {
        return new Complex(value);
    }

    @:from
    public static function fromInt(value:Int):Complex {
        return fromNumber(value);
    }

    @:from
    public static function fromFloat(value:Float):Complex {
        return fromNumber(value);
    }

    public function mod():Float {
        return if (realValue != 0 || imagValue != 0)
            Math.sqrt(realValue*realValue + imagValue*imagValue);
        else
            .0;
    }

    @:op(A + B)
    public function add(c:Complex):Complex {
        return new Complex(realValue + c.realValue, imagValue + c.imagValue);
    }

    @:op(A - B)
    public function sub(c:Complex):Complex {
        return new Complex(realValue - c.realValue, imagValue - c.imagValue);
    }

    @:op(A * B)
    public function mulComplex(c:Complex):Complex {
        return new Complex(
            realValue * c.realValue - imagValue * c.imagValue,
            realValue * c.imagValue + imagValue * c.realValue
        );
    }

    @:op(A * B)
    public function mul<T:Float>(n:T):Complex {
        return new Complex(realValue * n, imagValue * n);
    }

    @:op(A / B)
    public function divComplex(c:Complex):Complex {
        var den = Math.pow(c.mod(), 2);
        return new Complex(
            (realValue * c.realValue + imagValue * c.imagValue) / den,
            (imagValue * c.realValue - realValue * c.imagValue) / den
        );
    }

    @:op(A / B)
    public function div<T:Float>(n:T):Complex {
        return new Complex(realValue / n, imagValue / n);
    }

    public function cexp():Complex {
        var t = Math.exp(realValue);
        return new Complex(
            t * Math.cos(imagValue),
            t * Math.sin(imagValue)
        );
    }

    public function conjugate():Complex {
        return new Complex(realValue, -imagValue);
    }

    public function round(?precision:Int = 0):Complex {
        return new Complex(realValue.round(precision), imagValue.round(precision));
    }

    public function toString():String {
        return if (imagValue >= 0) 
            '${realValue}+${imagValue}j'
        else
            '${realValue}${imagValue}j';
    }
}