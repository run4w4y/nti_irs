package exceptions;

import exceptions.BaseException;


class TypeException extends BaseException {
    override public function toString():String {
        return 'TypeException($errorMessage)';
    }
}