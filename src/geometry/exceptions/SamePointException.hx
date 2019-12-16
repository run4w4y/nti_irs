package src.geometry.exceptions;

import src.exceptions.BaseException;

class SamePointException extends BaseException {
    override public function toString():String {
        return 'SamePointException($errorMessage)';
    }
}