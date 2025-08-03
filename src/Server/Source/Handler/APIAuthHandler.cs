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
    internal class APIAuthHandler : HandlerBase
    {
        public override string Type => "/api/auth";

        public override void PostHandle(HttpRequest request, HttpsSession session)
        {
            switch (request.Url)
            {
                case "/api/auth/login":
                    PostLogin(request, session);
                    break;
                case "/api/auth/logout":
                    PostLogout(request, session);
                    break;
                default:
                    ErrorHandle(session);
                    break;
            }
        }
        private void PostLogin(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();

            if (sessionManager.Authorization(request, out string id, session))
            {
                OkHandle(session);
                return;
            }

            var value = request.Body;
            var account = JsonHelper.Deserialize<Account>(value);
            if (account == null)
            {
                ErrorHandle(session);
                return;
            }

            // Đăng nhập thành công:
            string userId = AccountDatabase.Instance.CheckLoginAccount(account);

            if (!userId.IsNullOrEmpty())
            {
                var response = ResponseHelper.NewUserSession(userId, session.Response);

                session.SendResponseAsync(response); // gửi response
                return;
            }

            ErrorHandle(session);

        }
        private void PostLogout(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();

            if (sessionManager.RemoveCurrentSession(request, session))
                OkHandle(session);
            else
                ErrorHandle(session);
        }

    }
}
