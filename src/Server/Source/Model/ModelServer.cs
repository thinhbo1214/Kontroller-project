using Microsoft.IdentityModel.Abstractions;
using Microsoft.IdentityModel.Tokens;
using Server.Source.Controller;
using Server.Source.Core;
using Server.Source.Event;
using Server.Source.Manager;
using Server.Source.NetCoreServer;
using Server.Source.Presenter;
using Server.Source.View;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Security.Authentication;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace Server.Source.Model
{
    public class ModelServer
    {
        private string certificate = Path.Combine(AppContext.BaseDirectory, "tools", "certificates", "server.pfx");
        public string Certificate { get => certificate; set => certificate = value; }

        private string password = "qwerty";
        public string Password {get => password; set => password = value;}

        private int port = 443;
        public int Port { get => port; set => port = value; }

        private string www = Path.Combine(AppContext.BaseDirectory, "www", "ClientWeb");
        public string WWW { get => www; set => www = value; }

        private SslContext context;
        public SslContext Context { get => context; }

        private ServerController server;
        public ServerController Server { get => server; }

        public event Action CongfiguredServer;

        /// <summary>
        /// Hàng đợi log an toàn đa luồng để lưu trữ log chờ ghi.
        /// </summary>
        private readonly BlockingCollection<string> _logQueue = new();
        public event Action<string> OnAddedLog;

        public ModelServer() 
        {
            Init();

        }
        public static void Init()
        {
            // Manager
            Simulation.SetModel<LogManager>(new LogManager());
            Simulation.SetModel<SimulationManager>(new SimulationManager());
            Simulation.SetModel<SessionManager>(new SessionManager());
            Simulation.SetModel<DatabaseManager>(new DatabaseManager());

            // MVP
            Simulation.SetModel<ServerPresenter>(new ServerPresenter());
            Simulation.SetModel<ViewServer>(new ViewServer());
        }

        public void CongfigureServer(int port = -1, string www = "", string certificate = "")
        {
            Port = (port <= 0) ? Port : port; 
            Certificate = (certificate.IsNullOrEmpty()) ? Certificate : certificate;
            WWW = (www.IsNullOrEmpty()) ? WWW : www;

            context = new SslContext(SslProtocols.Tls13, new X509Certificate2(Certificate, Password));
            server = new ServerController(Context, IPAddress.Any, Port);
            server.AddStaticContent(WWW);

            // Kích hoạt sự kiện báo presenter hoặc view biết
            CongfiguredServer?.Invoke();
        }

        public void Log(string logEntry)
        {
            _logQueue.Add(logEntry);
            OnAddedLog?.Invoke(logEntry);
        }

    }
}
