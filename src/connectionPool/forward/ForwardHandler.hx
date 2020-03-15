package connectionPool.forward;

import connectionPool.request.RequestHandler;
import connectionPool.message.Types;
import connectionPool.message.ChildMessenger;


class ForwardHandler extends RequestHandler implements ChildMessenger {
    public var send:SendFunction;
    public var request:RequestFunction;
    public var response:ResponseFunction;
    public var waitForMessage:WaitFunction;
    public var waitForResponse:WaitFunction;

    /**
    {
        type: String, // Either 'Request' or 'Info'
        object: Dynamic,
        receiver: PoolMember
    }
    **/
    override public function call(args:Dynamic):Dynamic {
        if (args.type == 'Request') 
            return request(args.object, args.receiver)
        else {
            send(args.object, args.receiver);
            return null;
        }
    }
}