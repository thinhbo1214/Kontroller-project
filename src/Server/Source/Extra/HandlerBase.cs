using Server.Source.Helper;
using Server.Source.Interface;
using Server.Source.NetCoreServer;

namespace Server.Source.Extra
{
    public abstract class HandlerBase : IHandler
    {
        public abstract string Type { get; }

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
                    ErrorHandle(session); break;
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
        protected virtual void SendJsonResponse(HttpsSession session, object data, int statusCode)
        {
            var response = data != null
                ? ResponseHelper.MakeJsonResponse(session.Response, data, statusCode)
                : ResponseHelper.MakeJsonResponse(session.Response, statusCode);
            session.SendResponseAsync(response);
        }
        public virtual void ErrorHandle(HttpsSession session, object data = null)
        {
            SendJsonResponse(session, data, 400);
        }
        public virtual void OkHandle(HttpsSession session, object data = null)
        {
            SendJsonResponse(session, data, 200);
        }
    }
}
