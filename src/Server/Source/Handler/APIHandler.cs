using Server.Source.Event;
using Server.Source.Interface;
using Server.Source.NetCoreServer;
using static Server.Source.Core.Simulation;

namespace Server.Source.Handler
{
    internal class APIHandler
    {
        private readonly static List<IHandler> handlers = new()
        {
            GetModel<APICacheHandler>(),
            GetModel<APILoginHandler>(),
        };

        // Trả về IApiEvent thay vì Event gốc
        private readonly static Dictionary<Type, Func<IApiEvent>> handlerEventMap = new()
        {
            { typeof(APICacheHandler), () => Schedule<CacheEvent>(0.25f) },
            { typeof(APILoginHandler), () => Schedule<APILoginEvent>(0.25f) }
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
