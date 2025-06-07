using ServerConsole.Source.extra;
using ServerConsole.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;
using static System.Collections.Specialized.BitVector32;
using static ServerConsole.Source.Core.Simulation;
using ServerConsole.Source.Core;
using ServerConsole.Source.Event;

namespace ServerConsole.Source.main
{
    class HttpsSessionController : HttpsSession
    {
        public HttpsSessionController(HttpsServer server) : base(server)
        {

        }

        protected override void OnReceivedRequest(HttpRequest request)
        {
            // Show HTTP request content
            Console.WriteLine(request);
            //Console.WriteLine($"Request {request.Method} {request.Url}");

            // Lập lịch sự kiện
            var ev = Schedule<APIEvent>(0.25f);
            ev.request = new HttpRequestCopy(request);
            ev.session = this;

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
