package geometry.exceptions;

import exceptions.BaseException;

class SamePointException extends BaseException {
    override public function toString():String {
        return 'SamePointException($errorMessage)';
    }
}