using ServerConsole.Source.Core;
using ServerConsole.Source.Extra;
using ServerConsole.Source.Handler;
using ServerConsole.Source.Interface;
using ServerConsole.Source.Manager;
using ServerConsole.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ServerConsole.Source.Event
{
    public class APILoginEvent : Simulation.Event<APILoginEvent>, IApiEvent
    {
        public HttpRequest request { get; set; }
        public HttpsSession session { get; set; }
        public override void Execute()
        {
            if (request != null && session != null)
            {
                if (request != null && session != null)
                {
                    // Chạy luồng bất đồng bộ
                    Task.Run(async () =>
                    {
                        // Đảm bảo đồng độ ko quá nhiều luồng
                        await Simulation.GetModel<SimulationManager>().Limiter.WaitAsync();
                        try
                        {
                            Simulation.GetModel<APILoginHandler>().Handle(request, session);
                        }
                        catch (Exception ex)
                        {
                            Simulation.GetModel<LogManager>().Log("Lỗi trong APILoginEvent: " + ex.ToString(), LogLevel.ERROR);
                        }
                        finally
                        {
                            // Giải phóng luồng đã hoàn thành
                            Simulation.GetModel<SimulationManager>().Limiter.Release();
                        }
                    });

                }
            }
        }
    }
}
