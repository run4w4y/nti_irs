package constraints;

import exceptions.ValueException;

using tools.NullTools;


class Constraints {
    public static function checkRange(number:Float, left:Float, right:Float, ?errorMessage:String) {
        errorMessage = errorMessage.coalesce('number must be in the range [$left, $right]');
        if (number > right || number < left)
            throw new ValueException('Constraints check failed: $errorMessage');
    }

    public static function constrain(number:Float, left:Float, right:Float) {
        if (number < left)
            return left;
        if (number > right)
            return right;
        return number;
    }
}