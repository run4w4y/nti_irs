package connectionPool.message;

import connectionPool.message.Message;
import connectionPool.message.Types;


interface ChildMessenger {
    public var send:SendFunction;
    public var request:RequestFunction;
    public var response:ResponseFunction;
    public var waitForMessage:WaitFunction;
    public var waitForResponse:WaitFunction;
}