using Microsoft.IdentityModel.Tokens;
using Server.Source.Core;
using Server.Source.Data;
using Server.Source.Database;
using Server.Source.Extra;
using Server.Source.Helper;
using Server.Source.Manager;
using Server.Source.NetCoreServer;
using System.Reflection;


namespace Server.Source.Handler
{
    internal class APILoginHandler : HandlerBase
    {
        public override string Type => "/api/login";
        public override void Handle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();

            if (sessionManager.Authorization(request, out string id, session))
            {
                var response = ResponseHelper.MakeJsonResponse(session.Response, 200); // tạo response
                session.SendResponseAsync(response); // gửi response
                return;
            }

            var value = request.Body;
            var account = JsonHelper.Deserialize<Account>(value);
            if (account == null)
            {
                var errorResponse = ResponseHelper.MakeJsonResponse(session.Response, 400);
                session.SendResponseAsync(errorResponse);
                return;
            }

            // Đăng nhập thành công:
            string userId = AccountDatabase.Instance.CheckLoginAccount(account);
            Simulation.GetModel<LogManager>().Log(userId);

            if (!userId.IsNullOrEmpty())
            {
                var response = ResponseHelper.NewUserSession(userId, session.Response);

                session.SendResponseAsync(response); // gửi response
            }
            else
            {
                var errorResponse = ResponseHelper.MakeJsonResponse(session.Response, 400);
                session.SendResponseAsync(errorResponse);
            }
        }

    }
}
