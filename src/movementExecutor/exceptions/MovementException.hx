package movementExecutor.exceptions;

import exceptions.BaseException;


class MovementException extends BaseException {
    public function new(errorMessage:String):Void {
        super(errorMessage);
    }

    override public function toString():String {
        return 'MovementException($errorMessage)';
    }
}