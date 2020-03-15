package connectionPool.message;

import connectionPool.PoolMember;
import connectionPool.request.RequestForm;
import connectionPool.message.Message;


typedef SendFunction = (Dynamic, PoolMember) -> Void;
typedef RequestFunction = (RequestForm, PoolMember) -> Dynamic;
typedef ResponseFunction = Message -> Void;
typedef WaitFunction = Void -> Message;