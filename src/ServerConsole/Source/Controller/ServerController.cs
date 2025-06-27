using ServerConsole.Source.Core;
using ServerConsole.Source.MainApp;
using ServerConsole.Source.Manager;
using ServerConsole.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;

namespace ServerConsole.Source.Controller
{
    class ServerController : HttpsServer
    {
        public ServerController(SslContext context, IPAddress address, int port) : base(context, address, port) { }

        protected override SslSession CreateSession() { return new SessionController(this); }

        protected override void OnError(SocketError error)
        {
            Simulation.GetModel<LogManager>().Log($"HTTPS server caught an error: {error}", LogLevel.ERROR);
        }
    }
}
