package trik.robot.display.exceptions;

import exceptions.BaseException;


class RectangleSizeException extends BaseException {
    override public function toString():String {
        return 'RectangleSizeException($errorMessage)';
    }
}