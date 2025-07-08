using Server.Source.Handler;
using Server.Source.Core;
using Server.Source.Extra;
using Server.Source.Interface;
using Server.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Server.Source.Manager;

namespace Server.Source.Event
{
    internal class CacheEvent : Simulation.Event<CacheEvent>, IApiEvent
    {
        public HttpRequest request { get; set; }
        public HttpsSession session { get; set; }
        public override void Execute()
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
                        Simulation.GetModel<APICacheHandler>().Handle(request, session);
                    }
                    catch (Exception ex)               
                    {
                        session.SendResponseAsync(ResponseHelper.MakeJsonResponse(session.Response, 500));
                        Simulation.GetModel<LogManager>().Log("Lỗi trong APICacheEvent: " + ex.ToString(), LogLevel.ERROR);
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
