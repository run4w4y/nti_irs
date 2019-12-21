package app.tests.artag.exceptions;

import exceptions.BaseException;


class NoClueException extends BaseException {
    override public function toString():String {
        return 'NoClueException($errorMessage)';
    }
}