package src.exceptions;

class BaseException {
    public var errorMessage:String;

    public function new(errorMessage:String):Void {
        this.errorMessage = errorMessage;
    }

    public function toString():String {
        return 'BaseException($errorMessage)';
    }
}