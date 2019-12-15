package src.app.tests.exceptions;

import src.exceptions.BaseException;


class NoClueException extends BaseException {
    override public function toString():String {
        return 'NoClueException($errorMessage)';
    }
}