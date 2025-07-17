using Microsoft.IdentityModel.Tokens;
using Server.Source.Controller;
using Server.Source.Core;
using Server.Source.Manager;
using Server.Source.NetCoreServer;
using Server.Source.Presenter;
using Server.Source.View;
using System.Collections.Concurrent;

using System.Net;
using System.Security.Authentication;
using System.Security.Cryptography.X509Certificates;

namespace Server.Source.Model
{
    public class ModelServer
    {
        private static readonly string ExecutableDirectory = Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);

        private string certificate = Path.Combine(ExecutableDirectory, "extra_files", "tools", "certificates", "server.pfx");
        public string Certificate { get => certificate; set => certificate = value; }

        private string password = "qwerty";
        public string Password {get => password; set => password = value;}

        private int port = 2000;
        public int Port { get => port; set => port = value; }

        private string www = Path.Combine(ExecutableDirectory, "extra_files", "www", "ClientWeb");
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
        public event Action<LogSource,string> OnAddedLog;

        // Dữ liệu hiện
        public class ServerStatus
        {
            public TimeSpan ElapsedTime { get; set; }
            public int NumberRequest { get; set; }
            public int NumberUser { get; set; }
            public int Port { get; set; }

        }
        public event Action<ServerStatus> OnChangedData;

        private TimeSpan elapsedTime = TimeSpan.Zero;
        public TimeSpan ElapsedTime { get => elapsedTime; set { elapsedTime = value; NotifyChanged(); }  }


        private int numberRequest = 0;
        public int NumberRequest { get => numberRequest; set => numberRequest = value; }
        public void UpdateNumberRequest()
        {
            lock (this) 
            {
                NumberRequest++;
            }
        }

        private int numberUser = 0;
        public int NumberUser { get => numberUser; set => numberUser = value; }


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

        public void CongfigureServer(int port = -1, string certificate = "",string www = "")
        {
            if (!certificate.IsNullOrEmpty()) Certificate = certificate;
            if (!www.IsNullOrEmpty()) WWW = www;
            if (port > 0) Port = port;

            context = new SslContext(SslProtocols.Tls13, new X509Certificate2(Certificate, Password));
            server = new ServerController(Context, IPAddress.Any, Port);
            server.AddStaticContent(WWW);


            // Kích hoạt sự kiện báo presenter hoặc view biết
            CongfiguredServer?.Invoke();
        }

        public void Log(LogSource source, string logEntry)
        {
            _logQueue.Add(logEntry);
            OnAddedLog?.Invoke(source, logEntry);
        }

        private void NotifyChanged()
        {
            NumberUser = Simulation.GetModel<SessionManager>().NumberSession;

            OnChangedData?.Invoke(new ServerStatus
            {
                ElapsedTime = ElapsedTime,
                NumberRequest = NumberRequest,
                NumberUser = NumberUser,
                Port = Port,
            });
        }
    }
}
