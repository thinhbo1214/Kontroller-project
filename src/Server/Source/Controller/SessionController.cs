using Azure;
using Server.Source.Core;
using Server.Source.Event;
using Server.Source.Extra;
using Server.Source.Manager;
using Server.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;
using static Server.Source.Core.Simulation;
using static System.Collections.Specialized.BitVector32;

namespace Server.Source.Controller
{
    public class SessionController : HttpsSession
    {
        public SessionController(HttpsServer server) : base(server)
        {

        }

        protected override void OnReceivedRequest(HttpRequest request)
        {
            // Show HTTP request content
            //Console.WriteLine(request);
            string sessionId = CookieHelper.GetSession(request);
            if (!string.IsNullOrEmpty(sessionId))
            {
                int? userId = Simulation.GetModel<SessionManager>().GetUserId(sessionId);

                if (userId != null)
                {
                    Simulation.GetModel<LogManager>().Log($"[UserID {userId} ] Request {request.Method} {request.Url}");
                }
                else
                {
                    Simulation.GetModel<LogManager>().Log($"[Invalid SessionID {sessionId}] → Removing session cookie.");
                    CookieHelper.RemoveSession(this.Response);
                }
            }
            else
            {
                Simulation.GetModel<LogManager>().Log($"[SesionID {this.Id} ] Request {request.Method} {request.Url}");
            }

            // Lập lịch sự kiện
            var ev = Schedule<APIEvent>(0.25f);
            ev.request = new HttpRequestCopy(request);
            ev.session = this;

        }

        protected override void OnReceivedRequestError(HttpRequest request, string error)
        {
            Simulation.GetModel<LogManager>().Log($"Request error: {error}", LogLevel.ERROR);

        }
        protected override void OnError(SocketError error)
        {
            Simulation.GetModel<LogManager>().Log($"HTTPS session caught an error: {error}", LogLevel.ERROR);
        }
    }
}
