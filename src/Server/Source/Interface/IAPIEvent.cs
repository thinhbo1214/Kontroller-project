using Server.Source.NetCoreServer;

namespace Server.Source.Interface
{
    internal interface IApiEvent
    {
        public HttpRequest request { get; set; }
        public HttpsSession session { get; set; }
    }
}
