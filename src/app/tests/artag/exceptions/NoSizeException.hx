package src.app.tests.artag.exceptions;

import src.exceptions.BaseException;


class NoSizeException extends BaseException {
    override public function toString():String {
        return 'NoSizeException($errorMessage)';
    }
}