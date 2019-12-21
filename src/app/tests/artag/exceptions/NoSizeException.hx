package app.tests.artag.exceptions;

import exceptions.BaseException;


class NoSizeException extends BaseException {
    override public function toString():String {
        return 'NoSizeException($errorMessage)';
    }
}