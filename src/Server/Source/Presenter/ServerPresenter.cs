using Microsoft.VisualBasic.Logging;
using Server.Source.Controller;
using Server.Source.Core;
using Server.Source.Manager;
using Server.Source.Model;
using Server.Source.NetCoreServer;
using Server.Source.View;
using System;
using System.IO;
using System.Net;
using System.Security.Authentication;
using System.Security.Cryptography.X509Certificates;
using System.Threading;
using System.Threading.Tasks;
using static Server.Source.Model.ModelServer;

namespace Server.Source.Presenter
{
    public class ServerPresenter
    {
        public ServerPresenter()
        {

        }
        public void Init()
        {
            // listen to View
            Simulation.GetModel<ViewServer>().OnClickedStart += SetUp;
            Simulation.GetModel<ViewServer>().OnClickedStop += Stop;

            //listen to Model
            Simulation.GetModel<ModelServer>().CongfiguredServer += Start;
            Simulation.GetModel<ModelServer>().OnAddedLog += UpdateLog;
            Simulation.GetModel<ModelServer>().OnChangedData += UpdateStatus;

            //listean to LogManager
            Simulation.GetModel<LogManager>().OnLogPrinted += Log;
        }
        private static void Run()
        {
            Simulation.GetModel<LogManager>().Log("⚙️ LogManager.Start()", LogLevel.INFO, LogSource.SYSTEM);
            Simulation.GetModel<LogManager>().Start();

            Simulation.GetModel<LogManager>().Log("⚙️ SimulationManager.Start()", LogLevel.INFO, LogSource.SYSTEM);
            Simulation.GetModel<SimulationManager>().Start();

            Simulation.GetModel<LogManager>().Log("⚙️ SessionManager.Start()", LogLevel.INFO, LogSource.SYSTEM);
            Simulation.GetModel<SessionManager>().Start();

            Simulation.GetModel<LogManager>().Log("🚀 Server.Start()", LogLevel.INFO, LogSource.SYSTEM);
            Simulation.GetModel<ModelServer>().Server.Start();

            Simulation.GetModel<LogManager>().Log("✅ Server started!", LogLevel.INFO, LogSource.SYSTEM);
        }

        /// <summary>
        /// Khởi chạy Server Presenter trong nền (tự động).
        /// </summary>
        private void Start()
        {
            Task.Run(() => {
                try
                {
                    Run();
                }
                catch (Exception ex)
                {
                    Simulation.GetModel<LogManager>().Log(ex);
                }

            });
        }
        private void Stop()
        {
            Task.Run(() => {
                try
                {
                    Simulation.GetModel<SessionManager>().Stop();
                    Simulation.GetModel<SimulationManager>().Stop();
                    Simulation.GetModel<ModelServer>().Server.Stop();
                    Simulation.GetModel<LogManager>().Log("Server stopped.", LogLevel.INFO, LogSource.SYSTEM);
                }
                catch (Exception ex)
                {
                    Simulation.GetModel<LogManager>().Log(ex);
                }

            });
        }

        private void SetUp()
        {
            Task.Run(() => {
                try
                {
                    Simulation.GetModel<ModelServer>().CongfigureServer();
                }
                catch (Exception ex)
                {
                    Simulation.GetModel<LogManager>().Log(ex);
                }
            });
        }

        private void Log(LogSource source, string newlog)
        {
            Task.Run(() => {
                try
                {
                    Simulation.GetModel<ModelServer>().Log(source, newlog);
                }
                catch (Exception ex)
                {
                    Simulation.GetModel<LogManager>().Log(ex);
                }
            });
        }

        private void UpdateLog(LogSource source, string log)
        {
            Task.Run(() => {
                try
                {
                    Simulation.GetModel<ViewServer>().UpdateLogView(source, log);
                }
                catch (Exception ex)
                {
                    Simulation.GetModel<LogManager>().Log(ex);
                }
            });
        }

        private void UpdateStatus(ServerStatus status)
        {
            Task.Run(() => {
                try
                {
                    Simulation.GetModel<ViewServer>().UpdateStatus(status);
                }
                catch (Exception ex)
                {
                    Simulation.GetModel<LogManager>().Log(ex);
                }
            });
        }
    }
}
