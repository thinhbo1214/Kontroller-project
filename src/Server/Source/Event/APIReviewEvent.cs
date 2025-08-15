using Server.Source.Core;
using Server.Source.Handler;
using Server.Source.Helper;
using Server.Source.Interface;
using Server.Source.Manager;
using Server.Source.NetCoreServer;

namespace Server.Source.Event
{

    public class APIReviewEvent : Simulation.Event<APIReviewEvent>, IApiEvent
    {
        public HttpRequest request { get; set; }
        public HttpsSession session { get; set; }
        public override void Execute()
        {
            if (request != null && session != null)
            {
                if (request != null && session != null)
                {
                    // Chạy luồng bất đồng bộ
                    Task.Run(async () =>
                    {
                        // Đảm bảo đồng độ ko quá nhiều luồng
                        await Simulation.GetModel<SimulationManager>().Limiter.WaitAsync();
                        try
                        {
                            Simulation.GetModel<APIReviewHandler>().Handle(request, session);
                        }
                        catch (Exception ex)
                        {
                            session.SendResponseAsync(ResponseHelper.MakeJsonResponse(session.Response, 500));
                            Simulation.GetModel<LogManager>().Log("Lỗi trong API Review: " + ex.ToString(), LogLevel.ERROR, LogSource.SYSTEM);
                        }
                        finally
                        {
                            // Giải phóng luồng đã hoàn thành
                            Simulation.GetModel<SimulationManager>().Limiter.Release();
                        }
                    });

                }
            }
        }
    }
}
