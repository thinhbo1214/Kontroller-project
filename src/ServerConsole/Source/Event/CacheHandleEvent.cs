using ServerConsole.Source.Core;
using ServerConsole.Source.extra;
using ServerConsole.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerConsole.Source.Event
{
    internal class CacheHandleEvent : Simulation.Event<CacheHandleEvent>, IApiEvent
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
                    await ConcurrencyLimiter.Limiter.WaitAsync();
                    try
                    {
                        Simulation.GetModel<CacheHandler>().Handle(request, session);
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
