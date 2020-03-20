package robotModel.motor.exceptions;

import exceptions.BaseException;


class PortException extends BaseException {
    override public function toString():String {
        return 'PortException($errorMessage)';
    }
}
