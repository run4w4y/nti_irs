package app.tests.exceptions;

import exceptions.BaseException;


class NoClueException extends BaseException {
    override public function toString():String {
        return 'NoClueException($errorMessage)';
    }
}