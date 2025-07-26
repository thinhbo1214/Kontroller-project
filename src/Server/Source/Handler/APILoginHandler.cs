using Microsoft.IdentityModel.Tokens;
using Server.Source.Core;
using Server.Source.Data;
using Server.Source.Extra;
using Server.Source.Helper;
using Server.Source.Manager;
using Server.Source.NetCoreServer;


namespace Server.Source.Handler
{
    internal class APILoginHandler : HandlerBase
    {
        public override string Type => "/api/login";
        
        public string CheckAccount(string username = "", string password = "")
        {
            if (username == "admin" && password == "admin")
            {
                return "123";
            }
            return "";
        }
        public override void Handle(HttpRequest request, HttpsSession session)
        {
            string? oldToken = TokenHelper.GetToken(request); // lấy token từ request
            var sessionManager = Simulation.GetModel<SessionManager>();

            if (sessionManager.Authorization(request, out string id, session))
            {
                var response = ResponseHelper.MakeJsonResponse(session.Response, 200); // tạo response
                session.SendResponseAsync(response); // gửi response
                return;
            }

            var value = request.Body;
            var loginReq = JsonHelper.Deserialize<Account>(value);
            if (loginReq == null)
            {
                var errorResponse = ResponseHelper.MakeJsonResponse(session.Response, 400);
                session.SendResponseAsync(errorResponse);
                return;
            }

            // Đăng nhập thành công:
            string userId = CheckAccount(loginReq.username, loginReq.password);
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
