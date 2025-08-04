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
        private readonly Dictionary<string, Action<HttpRequest, HttpsSession>> PutRoutes;
        public APIUserHandler()
        {
            PutRoutes = new Dictionary<string, Action<HttpRequest, HttpsSession>>(StringComparer.OrdinalIgnoreCase)
            {
                ["/api/user/email"] = PutUserEmail,
                ["/api/user/avatar"] = PutUserAvatar,
                ["/api/user/username"] = PutUserUsername,
                ["/api/user/password"] = PutUserPassword,
                ["/api/user/forgetpassword"] = PutUserForgetPassword
            };
        }


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
            if (PutRoutes.TryGetValue(request.Url, out var handler))
            {
                handler.Invoke(request, session);
            }
            else
            {
                ErrorHandle(session);
            }

        }
        private T PutBase<T>(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();
            if (!sessionManager.Authorization(request, out string userId, session))
            {
                return default;
            }

            var newData = JsonHelper.AddPropertyAndDeserialize<T>(request.Body, "UserId", userId);
            return newData;
        }
        private void PutUserEmail(HttpRequest request, HttpsSession session)
        {
            var data = PutBase<object>(request, session);
            if (data == null || UserDatabase.Instance.ChangeEmail(data) != 1)
            {
                ErrorHandle(session);
                return;
            }
            OkHandle(session);
        }
        private void PutUserAvatar(HttpRequest request, HttpsSession session)
        {
            var data = PutBase<object>(request, session);
            if (data == null || UserDatabase.Instance.ChangeAvatar(data) != 1)
            {
                ErrorHandle(session);
                return;
            }
            OkHandle(session);
        }
        private void PutUserUsername(HttpRequest request, HttpsSession session)
        {
            var data = PutBase<object>(request, session);
            if (data == null || AccountDatabase.Instance.ChangeUsername(data) != 1)
            {
                ErrorHandle(session);
                return;
            }
            OkHandle(session);
        }
        private void PutUserPassword(HttpRequest request, HttpsSession session)
        {
            var data = PutBase<object>(request, session);
            if (data == null || AccountDatabase.Instance.ChangePassword(data) != 1)
            {
                ErrorHandle(session);
                return;
            }
            OkHandle(session);
        }
        private void PutUserForgetPassword(HttpRequest request, HttpsSession session)
        {
            var data = PutBase<object>(request, session);
            if (data == null || AccountDatabase.Instance.ForgetPassword(data) != 1)
            {
                ErrorHandle(session);
                return;
            }
            OkHandle(session);
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
