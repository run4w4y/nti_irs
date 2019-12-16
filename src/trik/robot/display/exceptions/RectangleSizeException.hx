package src.trik.robot.display.exceptions;

import src.exceptions.BaseException;


class RectangleSizeException extends BaseException {
    override public function toString():String {
        return 'RectangleSizeException($errorMessage)';
    }
}