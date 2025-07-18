using Server.Source.Core;
using Server.Source.Handler;
using Server.Source.Helper;
using Server.Source.Manager;
using Server.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Server.Source.Event
{
    public class APIUserEvent: Simulation.Event<APIUserEvent>
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
                            Simulation.GetModel<APIUserHandler>().Handle(request, session);
                        }
                        catch (Exception ex)
                        {
                            session.SendResponseAsync(ResponseHelper.MakeJsonResponse(session.Response, 500));
                            Simulation.GetModel<LogManager>().Log("Lỗi trong APIUserHandle: " + ex.ToString(), LogLevel.ERROR, LogSource.SYSTEM);
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
