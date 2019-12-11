package trik.exceptions;

import trik.exceptions.Exception;


class ArtagException implements Exception {
    public var errorMessage:String;
    
    public function new(errorMessage:String):Void {
        this.errorMessage = errorMessage;
    }

    public function toString():String {
        return 'ArtagException($errorMessage)';
    }
}