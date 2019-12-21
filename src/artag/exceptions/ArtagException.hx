package artag.exceptions;

import exceptions.BaseException;


class ArtagException extends BaseException {
    override public function toString():String {
        return 'ArtagException($errorMessage)';
    }
}