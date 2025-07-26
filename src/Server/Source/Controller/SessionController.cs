using Server.Source.Core;
using Server.Source.Event;
using Server.Source.Extra;
using Server.Source.Manager;
using Server.Source.Model;
using Server.Source.NetCoreServer;
using System.Net.Sockets;
using static Server.Source.Core.Simulation;

namespace Server.Source.Controller
{
    public class SessionController : HttpsSession
    {
        public SessionController(HttpsServer server) : base(server)
        {

        }

        protected override void OnReceivedRequest(HttpRequest request)
        {
            Simulation.GetModel<ModelServer>().UpdateNumberRequest();

            if (Simulation.GetModel<SessionManager>().Authorization(request, out string userId, this))
            {
                Simulation.GetModel<LogManager>().Log($"[UserID: {userId} ] Request {request.Method} {request.Url}");
            }
            else
            {
                Simulation.GetModel<LogManager>().Log($"[UserID: {userId} Unknown] Request {request.Method} {request.Url}");
            }

            // Lập lịch sự kiện
            var ev = Schedule<APIEvent>(0.25f);
            ev.request = new HttpRequestCopy(request);
            ev.session = this;

        }
        protected override void OnReceivedRequestError(HttpRequest request, string error)
        {
            Simulation.GetModel<LogManager>().Log($"Request error: {error}", LogLevel.ERROR, LogSource.SYSTEM);

        }
        protected override void OnError(SocketError error)
        {
            Simulation.GetModel<LogManager>().Log($"HTTPS session caught an error: {error}", LogLevel.ERROR, LogSource.SYSTEM);
        }
    }
}
