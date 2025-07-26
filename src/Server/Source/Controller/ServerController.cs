using Server.Source.Core;
using Server.Source.Manager;
using Server.Source.NetCoreServer;
using System.Net;
using System.Net.Sockets;

namespace Server.Source.Controller
{
    public class ServerController : HttpsServer
    {
        public ServerController(SslContext context, IPAddress address, int port) : base(context, address, port) { }

        protected override SslSession CreateSession() { return new SessionController(this); }

        protected override void OnError(SocketError error)
        {
            Simulation.GetModel<LogManager>().Log($"HTTPS server caught an error: {error}", LogLevel.ERROR, LogSource.SYSTEM);
        }
    }
}
