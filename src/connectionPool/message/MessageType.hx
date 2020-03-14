package connectionPool.message;

import connectionPool.message.Message;


enum MessageType {
    Request(msg:Message);
    Response(msg:Message);
    Info(msg:Message);
}