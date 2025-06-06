using ServerConsole.Source.Core;
using ServerConsole.Source.Event;
using ServerConsole.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using static ServerConsole.Source.Core.Simulation;

namespace ServerConsole.Source.extra
{
    internal class APIHandler
    {
        private readonly static List<IHttpsHandler> handlers = new()
        {
            Simulation.GetModel<CacheHandler>(),
            Simulation.GetModel<LoginHandler>(),
        };

        // Trả về IApiEvent thay vì Event gốc
        private readonly static Dictionary<Type, Func<IApiEvent>> handlerEventMap = new()
        {
            { typeof(CacheHandler), () => Schedule<CacheHandleEvent>(0.25f) },
            { typeof(LoginHandler), () => Schedule<LoginHandlerEvent>(0.25f) }
        };

        public void Handle(HttpRequest request, HttpsSession session)
        {
            string key = request.Url;
            var handler = handlers.FirstOrDefault(h => h.CanHandle(key));

            if (handler != null && handlerEventMap.TryGetValue(handler.GetType(), out var scheduleFunc))
            {
                var ev = scheduleFunc();  // Đây là IApiEvent
                ev.request = request;
                ev.session = session;
            }
        }
    }
}
