using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerConsole.Source.extra
{
    internal class HttpsHandlerFactory
    {
        private readonly List<IHttpsHandler> handlers;

        public HttpsHandlerFactory()
        {
            handlers = new List<IHttpsHandler>()
            {
                new CacheHandler(),
                new LoginHandler(),
                // Thêm các handler khác ở đây
            };
        }

        public IHttpsHandler? GetHandler(string path)
        {
            return handlers.FirstOrDefault(h => h.CanHandle(path));
        }
    }
}
