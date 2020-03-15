package connectionPool.request;

import connectionPool.request.RequestHandler;


typedef RequestForm = {
    handler:RequestHandler,
    ?args:Dynamic
}