using NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerConsole.Source.extra
{
    internal class LoginHandler //: IHttpsHandler
    {
        public string Type => "/api/login";
        public string DecodKeyValue(string key) => ((IHttpsHandler)this).DecodKeyValue(key);
        public void Handle(HttpRequest request, HttpsSession session)
        {
            var rawKey = request.Url; 
            var decodedKey = DecodKeyValue(rawKey);
            Console.WriteLine($"Decoded login key: {decodedKey}");
        }

    }
}
