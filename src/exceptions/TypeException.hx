package src.exceptions;

import src.exceptions.BaseException;


class TypeException extends BaseException {
    override public function toString():String {
        return 'TypeException($errorMessage)';
    }
}