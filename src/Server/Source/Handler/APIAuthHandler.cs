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

        public APIAuthHandler() 
        {
            PostRoutes["/api/auth/login"] = PostLogin;
            PostRoutes["/api/auth/logout"] = PostLogout;
            PostRoutes["/api/auth/forgetpassword"] = PostForgetPassword;
        }
        private void PostLogin(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();

            if (sessionManager.Authorization(request, out string id, session))
            {

                ErrorHandle(session, "Không thể đăng ký tài khoản, đã đăng nhập rồi!");
                return;
            }

            var value = request.Body;
            var account = JsonHelper.Deserialize<Account>(value);
            if (account == null)
            {
                ErrorHandle(session, "Tài khoản hoặc mật khẩu không có giá trị!");
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

            ErrorHandle(session, "Tài khoản không hợp lệ hoặc đã được dùng!");

        }
        private void PostLogout(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();

            if (sessionManager.Authorization(request, out string id, session) == false)
            {
                ErrorHandle(session, "Chưa đăng nhập, không thể đăng xuất!");
                return;
            }

            if (sessionManager.RemoveCurrentSession(request, session))
                OkHandle(session);
            else
                ErrorHandle(session, "Có lỗi khi đăng xuất, hãy thử lại!");
        }

        /// <summary>Thực hiện quên mật khẩu cho người dùng.</summary>
        private void PostForgetPassword(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();

            if (sessionManager.Authorization(request, out string id, session))
            {
                ErrorHandle(session, "Đã đăng nhập, không thể quên mật khẩu!");
                return;
            }

            var data = JsonHelper.Deserialize<ForgetPasswordParams>(request.Body);
            
            if (data == null)
            {
                ErrorHandle(session, "Email không có giá trị");
                return;
            }
            var newPassword = AccountDatabase.Instance.ForgetPassword(data);
            Simulation.GetModel<NotifyManager>().SendMailResetPassword(data.Email, newPassword);
            OkHandle(session, "Mật khẩu của bạn đã reset, hãy check mail của bạn!");
        }

    }
}
