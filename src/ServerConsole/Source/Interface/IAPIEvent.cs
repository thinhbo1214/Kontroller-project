using ServerConsole.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerConsole.Source.Interface
{
    internal interface IApiEvent
    {
        public HttpRequest request { get; set; }
        public HttpsSession session { get; set; }
    }
}
