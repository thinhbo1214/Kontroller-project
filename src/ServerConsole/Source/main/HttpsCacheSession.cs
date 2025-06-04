using NetCoreServer;
using ServerConsole.Source.extra;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;
using static System.Collections.Specialized.BitVector32;

namespace ServerConsole.Source.main
{
    class HttpsSessionController : HttpsSession
    {
        private readonly HttpsHandlerFactory handlerFactory;
        public HttpsSessionController(HttpsServer server) : base(server)
        {
            handlerFactory = new HttpsHandlerFactory();

        }

        protected override void OnReceivedRequest(HttpRequest request)
        {
            // Show HTTP request content
            Console.WriteLine(request);
            //Console.WriteLine($"Request {request.Method} {request.Url}");

            var handler = handlerFactory.GetHandler(request.Url);

            if (handler != null)
            {
                handler.Handle(request, this);
            }
            else
                SendResponseAsync(Response.MakeErrorResponse(404, "Unknown API route"));

        }

        protected override void OnReceivedRequestError(HttpRequest request, string error)
        {
            Console.WriteLine($"Request error: {error}");
        }

        protected override void OnError(SocketError error)
        {
            Console.WriteLine($"HTTPS session caught an error: {error}");
        }
    }
}
