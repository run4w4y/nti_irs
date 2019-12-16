package src.artag.exceptions;

import src.exceptions.BaseException;


class ArtagException extends BaseException {
    override public function toString():String {
        return 'ArtagException($errorMessage)';
    }
}