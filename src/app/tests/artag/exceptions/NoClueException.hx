package src.app.tests.artag.exceptions;

import src.exceptions.BaseException;


class NoClueException extends BaseException {
    override public function toString():String {
        return 'NoClueException($errorMessage)';
    }
}