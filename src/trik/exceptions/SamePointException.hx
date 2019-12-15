package src.trik.exceptions;

import src.trik.exceptions.Exception;


class SamePointException implements Exception {
    public var errorMessage:String;
    
    public function new(errorMessage):Void {
        this.errorMessage = errorMessage;
    }

    public function toString():String {
        return 'SamePointException($errorMessage)';
    }
}