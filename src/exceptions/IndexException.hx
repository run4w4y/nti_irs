package exceptions;

import exceptions.BaseException;

class IndexException extends BaseException {
    override public function toString():String {
        return 'IndexException($errorMessage)';
    }
}