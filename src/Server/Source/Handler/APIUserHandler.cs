using Microsoft.IdentityModel.Tokens;
using Microsoft.VisualBasic.ApplicationServices;
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
    using User = Server.Source.Data.User;
    internal class APIUserHandler : HandlerBase
    {
        public override string Type => "/api/user";
        public override void GetHandle(HttpRequest request, HttpsSession session)
        {
            var userId = DecodeHelper.GetParamWithURL("userId", request.Url);

            if (string.IsNullOrEmpty(userId))
            {
                string token = TokenHelper.GetToken(request);
                if (TokenHelper.TryParseToken(token, out var sessionId))
                {
                    userId = Simulation.GetModel<SessionManager>().GetUserId(sessionId);
                }
            }

            if (string.IsNullOrEmpty(userId))
            {
                ErrorHandle(session);
                return;
            }

            var userInfo = DatabaseHelper.GetData<User>(userId);
            OkHandle(session, userInfo);
        }

        public override void PostHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();

            //Nếu đã đăng nhập và phiên còn hạn
            if (sessionManager.Authorization(request, out string id, session))
            {
                OkHandle(session);
                return;
            }

            var value = request.Body;
            var account = JsonHelper.Deserialize<Account>(value);
            // Gưi dữ liệu ko đủ
            if (account == null)
            {
                ErrorHandle(session);
                return;
            }

            // Đăng ký thành công:
            string userId = AccountDatabase.Instance.CreateAccount(account);
            Simulation.GetModel<LogManager>().Log(account.ToString());
            if (!userId.IsNullOrEmpty())
            {
                var response = ResponseHelper.NewUserSession(userId, session.Response);
                session.SendResponseAsync(response); // gửi response
                return;
            }
            
            ErrorHandle(session);
        }
        public override void PutHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();
            if (!sessionManager.Authorization(request, out string userId, session))
            {
                ErrorHandle(session);
                return;
            }

            switch (request.Url)
            {
                case "/api/user/email":
                    PutUserEmail(request, session);
                    break;
                case "/api/user/avatar":
                    PutUserAvatar(request, session);
                    break;
                case "/api/user/username":
                    PutUserUsername(request, session);
                    break;
                case "/api/user/password":
                    PutUserPassword(request, session);
                    break;
                case "/api/user/forgetpassword":
                    PutUserForgetPassword(request, session);
                    break;
                default:
                    ErrorHandle(session);
                    break;
            }

        }
        private void PutUserEmail(HttpRequest request, HttpsSession session)
        {
            object data = JsonHelper.Deserialize<object>(request.Body);
            if (UserDatabase.Instance.ChangeEmail(data) == 1)
            {
                OkHandle(session);
                return;
            }
            ErrorHandle(session);
        }
        private void PutUserAvatar(HttpRequest request, HttpsSession session)
        {
            object data = JsonHelper.Deserialize<object>(request.Body);
            if (UserDatabase.Instance.ChangeAvatar(data) == 1)
            {
                OkHandle(session);
                return;
            }
            ErrorHandle(session);
        }
        private void PutUserUsername(HttpRequest request, HttpsSession session)
        {
            object data = JsonHelper.Deserialize<object>(request.Body);
            if (AccountDatabase.Instance.ChangeUsername(data) == 1)
            {
                OkHandle(session);
                return;
            }
            ErrorHandle(session);
        }
        private void PutUserPassword(HttpRequest request, HttpsSession session)
        {
            object data = JsonHelper.Deserialize<object>(request.Body);
            if (AccountDatabase.Instance.ChangePassword(data) == 1)
            {
                OkHandle(session);
                return;
            }
            ErrorHandle(session);
        }
        private void PutUserForgetPassword(HttpRequest request, HttpsSession session)
        {
            object data = JsonHelper.Deserialize<object>(request.Body);
            if (AccountDatabase.Instance.ForgetPassword(data) == 1)
            {
                OkHandle(session);
                return;
            }
            ErrorHandle(session);
        }

        public override void DeleteHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();
            if (!sessionManager.Authorization(request, out string userId, session))
            {
                ErrorHandle(session);
                return;
            }
            var data = JsonHelper.Deserialize<DeleteAccountRequest>(request.Body);

            if (AccountDatabase.Instance.Delete(data) == 1)
            {
                OkHandle(session);
                return;
            }
            ErrorHandle(session);
        }

    }
}
