using ServerConsole.Source.Core;
using ServerConsole.Source.Extra;
using ServerConsole.Source.NetCoreServer;
using ServerConsole.Source.Handler;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerConsole.Source.Event
{
    internal class APIEvent : Simulation.Event<APIEvent>
    {
        public HttpRequest? request;
        public HttpsSession? session;
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
                        await ConcurrencyLimiter.Limiter.WaitAsync();
                        try
                        {
                            Simulation.GetModel<APIHandler>().Handle(request, session);

                        }
                        finally
                        {
                            // Giải phóng luồng đã hoàn thành
                            ConcurrencyLimiter.Limiter.Release();
                        }
                    });

                }
            }
            
        }
    }
}
