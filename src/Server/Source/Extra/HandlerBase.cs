using Server.Source.Interface;
using Server.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace Server.Source.Extra
{
    public abstract class HandlerBase : IHandler
    {
        public abstract string Type { get; }

        public virtual string DecodKeyValue(string key)
        {
            // Decode the key value
            key = Uri.UnescapeDataString(key);
            key = key.Replace(Type, "", StringComparison.InvariantCultureIgnoreCase);
            key = key.Replace("?key=", "", StringComparison.InvariantCultureIgnoreCase);

            return key;
        }

        public virtual bool CanHandle(string path) => path.StartsWith(Type, StringComparison.OrdinalIgnoreCase);
        public virtual void Handle(HttpRequest request, HttpsSession session) 
        {
            switch (request.Method.ToUpper())
            { 
                case "HEAD":
                    HeadHandle(session); break;
                case "GET":
                    GetHandle(request, session); break;
                case "POST":
                    PostHandle(request, session); break;
                case "PUT":
                    PutHandle(request, session); break;
                case "DELETE":
                    DeleteHandle(request, session); break;
                case "OPTION":
                    OptionsHandle(request, session); break;
                case "TRACE":
                    TraceHandle(request, session); break;
                default:
                    ErrorHandle(request, session); break;
            }
        }
        public virtual void HeadHandle(HttpsSession session) 
        {
            session.SendResponseAsync(session.Response.MakeHeadResponse());
        }
        public virtual void GetHandle(HttpRequest request, HttpsSession session) { }
        public virtual void PostHandle(HttpRequest request, HttpsSession session) { }
        public virtual void PutHandle(HttpRequest request, HttpsSession session) { }
        public virtual void DeleteHandle(HttpRequest request, HttpsSession session) { }
        public virtual void OptionsHandle(HttpRequest request, HttpsSession session)
        {
            session.SendResponseAsync(session.Response.MakeOptionsResponse());
        }
        public virtual void TraceHandle(HttpRequest request, HttpsSession session)
        {
            session.SendResponseAsync(session.Response.MakeTraceResponse(request));
        }
        public virtual void ErrorHandle(HttpRequest request, HttpsSession session)
        {
            session.SendResponseAsync(session.Response.MakeErrorResponse("Unsupported HTTP method: " + request.Method));
        }
    }
}
