using NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace ServerConsole.Source.extra
{
    internal interface IHttpsHandler
    {
        string Type { get; }
        string DecodKeyValue(string key)
        {
            // Decode the key value
            key = Uri.UnescapeDataString(key);
            key = key.Replace(Type, "", StringComparison.InvariantCultureIgnoreCase);
            key = key.Replace("?key=", "", StringComparison.InvariantCultureIgnoreCase);

            return key;
        }
        bool CanHandle(string path)
        {
            return path.StartsWith(Type, StringComparison.OrdinalIgnoreCase);
        }
        void Handle(HttpRequest request, HttpsSession session);
        void HeadHandle(HttpsSession session);
        void GetHandle(HttpRequest request, HttpsSession session);
        void PostHandle(HttpRequest request, HttpsSession session);
        void PutHandle(HttpRequest request, HttpsSession session);
        void DeleteHandle(HttpRequest request, HttpsSession session);
        void OptionsHandle(HttpRequest request, HttpsSession session)
        {
            session.SendResponseAsync(session.Response.MakeOptionsResponse());
        }
        void TraceHandle(HttpRequest request, HttpsSession session)
        {
            session.SendResponseAsync(session.Response.MakeTraceResponse(request));
        }
        void ErrorHandle(HttpRequest request, HttpsSession session)
        {
            session.SendResponseAsync(session.Response.MakeErrorResponse("Unsupported HTTP method: " + request.Method));
        }

    }
}
