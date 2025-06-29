using ServerConsole.Source.Controller;
using ServerConsole.Source.Core;
using ServerConsole.Source.Manager;
using ServerConsole.Source.NetCoreServer;
using System;
using System.IO;
using System.Net;
using System.Security.Authentication;
using System.Security.Cryptography.X509Certificates;
using System.Threading;
using System.Threading.Tasks;

namespace ServerConsole.Source.Presenter
{
    public class ServerPresenter
    {
        private string certificate;
        private string password;
        private int port;
        private string www;
        private SslContext context;
        private ServerController server;

        /// <summary>
        /// Bộ điều khiển tín hiệu hủy để dừng task một cách an toàn.
        /// </summary>
        private CancellationTokenSource _cts = new();

        /// <summary>
        /// Task xử lý nền.
        /// </summary>
        /// 
        private Task _presenterTask;


        /// <summary>
        /// Khởi chạy Server Presenter trong nền (tự động).
        /// </summary>
        public void Start()
        {
            if (_presenterTask != null && !_presenterTask.IsCompleted)
                return; // đã chạy rồi

            if (_cts.IsCancellationRequested)
                _cts = new CancellationTokenSource(); // Reset token nếu đã huỷ trước đó

            certificate = Path.Combine(AppContext.BaseDirectory, @"..\..\..\tools\certificates\server.pfx");
            password = "qwerty";
            port = 8443;
            www = Path.Combine(AppContext.BaseDirectory, @"../../../www/ClientWeb");

            context = new SslContext(SslProtocols.Tls13, new X509Certificate2(certificate, password));
            server = new ServerController(context, IPAddress.Any, port);
            server.AddStaticContent(www);

            //Simulation.GetModel<LogManager>().Log($"HTTPS server website: https://localhost:{port}/api/index.html");

            Simulation.GetModel<LogManager>().Log("Server starting...");
            server.Start();
            Simulation.GetModel<LogManager>().Log("Server started...");

            Simulation.GetModel<LogManager>().Log("Server Presenter starting...");
            _presenterTask = Task.Run(() => Run(_cts.Token));
        }

        /// <summary>
        /// Restart component
        /// </summary>
        public void Restart()
        {
            server.Restart();
            Stop();
            Start();
        }

        /// <summary>
        /// Dừng server presenter và toàn bộ task nền.
        /// </summary>
        public void Stop()
        {
            _cts.Cancel();

            server.Stop();
            Simulation.GetModel<LogManager>().Log("Server stopped...");

            try
            {
                _presenterTask?.Wait();
            }
            catch (AggregateException ae)
            {
                ae.Handle(e => e is OperationCanceledException);
            }

            Simulation.GetModel<LogManager>().Log("ServerPresenter stopped.");
        }

        /// <summary>
        /// Vòng lặp chính của Presenter, chạy nền.
        /// </summary>
        /// <param name="token">CancellationToken để dừng an toàn</param>
        private async Task Run(CancellationToken token)
        {
            try
            {
                Simulation.GetModel<LogManager>().Log("Server Presenter started...");

                while (!token.IsCancellationRequested)
                {
                    // Do something
                    await Task.Delay(1000, token); // giảm CPU load
                }

            }
            catch (Exception ex)
            {
                Simulation.GetModel<LogManager>().Log(ex);
            }
        }
    }
}
