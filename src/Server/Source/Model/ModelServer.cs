using Microsoft.IdentityModel.Tokens;
using Server.Source.Controller;
using Server.Source.Core;
using Server.Source.Manager;
using Server.Source.NetCoreServer;
using Server.Source.Presenter;
using Server.Source.View;
using System.Collections.Concurrent;
using System.Diagnostics; // Cho PerformanceCounter và Process
using System.Net;
using System.Security.Authentication;
using System.Security.Cryptography.X509Certificates;

namespace Server.Source.Model
{
    public class ModelServer
    {
        private static readonly PerformanceCounter CpuCounter = new("Processor", "% Processor Time", "_Total");

        //private static readonly string ExecutableDirectory = Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
        private static readonly string ExecutableDirectory = AppDomain.CurrentDomain.BaseDirectory;

        private string certificate = Path.Combine(ExecutableDirectory, "extra_files", "tools", "certificates", "server.pfx");
        public string Certificate { get => certificate; set => certificate = value; }

        private string password = "qwerty";
        public string Password {get => password; set => password = value;}

        private string ip = "192.168.1.5";
        public string IP { get => ip; set => ip = value; }

        private int port = 2000;
        public int Port { get => port; set => port = value; }

        private string www = Path.Combine(ExecutableDirectory, "extra_files", "www", "Kontroller Web");
        public string WWW { get => www; set => www = value; }

        private SslContext context;
        public SslContext Context { get => context; }

        private ServerController server;
        public ServerController Server { get => server; }

        public event Action CongfiguredServer;

        public bool IsAutoConfig { get; set; } = true;

        /// <summary>
        /// Bộ điều khiển tín hiệu hủy để dừng task một cách an toàn.
        /// </summary>
        private CancellationTokenSource _cts = new();

        /// <summary>
        /// Task xử lý nền.
        /// </summary>
        private Task? _cleanerTask;

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

            private float cpuUsage;
            public float CpuUsage { get => cpuUsage; set => cpuUsage = (value >= 100) ? 0 : value; }
            public string MemoryUsage { get; set; }

            public static async Task<ServerStatus> CollectAsync(TimeSpan elapsed, int requests, int users)
            {
                float cpu = await GetCpuUsageAsync();
                string memory = GetMemoryUsage();

                return new ServerStatus
                {
                    ElapsedTime = elapsed,
                    NumberRequest = requests,
                    NumberUser = users,
                    CpuUsage = cpu,
                    MemoryUsage = memory
                };
            }
            private static async Task<float> GetCpuUsageAsync()
            {
                CpuCounter.NextValue(); // discard first
                await Task.Delay(500);  // wait
                return CpuCounter.NextValue();
            }

            private static string GetMemoryUsage()
            {
                var proc = Process.GetCurrentProcess();
                long memoryBytes = proc.WorkingSet64;
                return (memoryBytes / (1024.0 * 1024)).ToString("0.0") + " MB";
            }

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

        private async void NotifyChanged()
        {
            NumberUser = Simulation.GetModel<SessionManager>().NumberSession;

            var status = await ServerStatus.CollectAsync(
                ElapsedTime,
                NumberRequest,
                NumberUser
            );

            OnChangedData?.Invoke(status);

        }
        /// <summary>
        /// Bắt đầu task nền dọn session hết hạn.
        /// </summary>
        public void Start()
        {
            if (_cleanerTask != null && !_cleanerTask.IsCompleted)
                return;

            if (_cts.IsCancellationRequested)
                _cts = new CancellationTokenSource();

            _cleanerTask = Task.Run(() => Run(_cts.Token));
        }

        /// <summary>
        /// Dừng task dọn session.
        /// </summary>
        public void Stop()
        {
            _cts.Cancel();

            try
            {
                _cleanerTask?.Wait();
            }
            catch (AggregateException ae)
            {
                ae.Handle(e => e is OperationCanceledException);
            }
            Simulation.GetModel<LogManager>().Log("ModelServer stopped.", LogLevel.INFO, LogSource.SYSTEM);
        }

        /// <summary>
        /// Vòng lặp chạy nền
        /// </summary>
        private async Task Run(CancellationToken token)
        {
            while (!token.IsCancellationRequested)
            {
                try
                {
                    Simulation.GetModel<ModelServer>().ElapsedTime += TimeSpan.FromMilliseconds(1000);
                    NotifyChanged();
                    await Task.Delay(1_000, token); // chạy mỗi 1s
                }
                catch (OperationCanceledException)
                {
                    break;
                }
                catch (Exception ex)
                {
                    Simulation.GetModel<LogManager>()?.Log(ex); // nếu cần log lỗi
                    await Task.Delay(1000, token);
                }
            }
        }

    }
}
