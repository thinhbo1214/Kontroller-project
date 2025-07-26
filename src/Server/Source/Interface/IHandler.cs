using Server.Source.NetCoreServer;
namespace Server.Source.Interface
{
    internal interface IHandler
    {
        string Type { get; }
        bool CanHandle(string path);
        void Handle(HttpRequest request, HttpsSession session);

    }
}
