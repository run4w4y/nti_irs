package connectionPool.message;

import connectionPool.message.Message;


class Receiver {
    public static function waitForResponse(response:Message -> Void):Message {
        while (true) {
            var received = Message.receive();

            switch (received) {
                case Response(m):
                    return m.object;
                case Request(m):
                    response(m);
                case _:
                    continue;
            }
        }
    }

    public static function waitForMessage(response:Message -> Void):Message {
        while (true) {
            var received = Message.receive();
            
            switch (received) {
                case Info(m):
                    return m;
                case Request(m):
                    response(m);
                case _:
                    continue;
            }
        }
    }
}