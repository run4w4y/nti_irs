package exceptions;

import exceptions.BaseException;

class ValueException extends BaseException {
    override public function toString():String {
        return 'ValueException($errorMessage)';
    }
}