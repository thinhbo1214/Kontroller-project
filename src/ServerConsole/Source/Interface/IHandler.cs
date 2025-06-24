using ServerConsole.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace ServerConsole.Source.Interface
{
    internal interface IHandler
    {
        string Type { get; }
        bool CanHandle(string path);
        void Handle(HttpRequest request, HttpsSession session);

    }
}
