package connectionPool.request;

import connectionPool.request.RequestHandler;


typedef RequestForm = {
    handler:RequestHandler,
    ?params:Array<Dynamic>
}