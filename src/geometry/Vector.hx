package geometry;

import geometry.Point;
import geometry.PointLike;


class Vector extends Point {
    public function new(?x:Float=0, ?y:Float=0):Void {
        super(x, y);
    }

    public static function fromPointLike<T:PointLike>(pointLike:T):Vector {
        return new Vector(pointLike.x, pointLike.y);
    }

    override public function add<T:PointLike>(pointLike:T):Vector {
        return new Vector(this.x + pointLike.x, this.y + pointLike.y);
    }

    override public function neg():Vector {
        return new Vector(-this.x, -this.y);
    }

    override public function sub<T:PointLike>(pointLike:T):Vector {
        return new Vector(this.x - pointLike.x, this.y - pointLike.y);
    }

    override public function mul(k:Float):Vector {
        return new Vector(this.x * k, this.y * k);
    }

    override public function div(k:Float):Vector {
        return new Vector(this.x / k, this.y / k);
    }

    public function scalar_product<T:PointLike>(pointLike:T):Float {
        return this.x * pointLike.x + this.y * pointLike.y;
    }

    public function vector_product<T:PointLike>(pointLike:T) {
        return this.x * pointLike.y - this.y * pointLike.x;
    }

    public function length():Float {
        return scalar_product(this);
    }
}