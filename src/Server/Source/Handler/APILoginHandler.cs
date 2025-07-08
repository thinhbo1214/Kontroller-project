using Server.Source.Core;
using Server.Source.Extra;
using Server.Source.Manager;
using Server.Source.NetCoreServer;
using Server.Source.Data;


namespace Server.Source.Handler
{
    internal class APILoginHandler : HandlerBase
    {
        public override string Type => "/api/login";
        
        public int CheckAccount(string username = "", string password = "")
        {
            if (username == "admin" && password == "admin")
            {
                return 123;
            }
            return -1;
        }
        public override void Handle(HttpRequest request, HttpsSession session)
        {
            string? oldToken = TokenHelper.GetToken(request); // lấy token từ request
            var sessionManager = Simulation.GetModel<SessionManager>();

            if (sessionManager.Authorization(request, out int id, session))
            {
                var response = ResponseHelper.MakeJsonResponse(session.Response, 200); // tạo response
                session.SendResponseAsync(response); // gửi response
                return;
            }

            var value = request.Body;
            var loginReq = JsonHelper.Deserialize<UserAccount>(value);
            if (loginReq == null)
            {
                var errorResponse = ResponseHelper.MakeJsonResponse(session.Response, 400);
                session.SendResponseAsync(errorResponse);
                return;
            }

            // Đăng nhập thành công:
            int userId = CheckAccount(loginReq.username, loginReq.password);
            if (userId > 0)
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
