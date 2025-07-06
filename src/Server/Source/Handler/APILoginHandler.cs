using Azure;
using Microsoft.VisualBasic.ApplicationServices;
using Newtonsoft.Json.Linq;
using Server.Source.Core;
using Server.Source.Event;
using Server.Source.Extra;
using Server.Source.Manager;
using Server.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Collections.Specialized.BitVector32;

namespace Server.Source.Handler
{
    internal class APILoginHandler : HandlerBase
    {
        public class LoginRequest
        {
            public string username { get; set; }
            public string password { get; set; }
            public LoginRequest()
            {
                username = "";
                password = "";
            }
        }
        public override string Type => "/api/login";
        
        public HttpResponse NewUserSession(int userId, HttpResponse response)
        {
            string newSessionId = Guid.NewGuid().ToString(); // sessionId mới
            Simulation.GetModel<SessionManager>().Store(newSessionId, userId);         // lưu phiên

            var token = TokenHelper.CreateToken(newSessionId, 60); // tạo token
            response = JsonHelper.MakeJsonResponse(response, new { message = "Login success", userId = userId }, 200, token); // tạo response

            return response;
        }
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
                var response = JsonHelper.MakeJsonResponse(session.Response, new { message = "Login success", userId = id }); // tạo response
                session.SendResponseAsync(response); // gửi response

                return;
            }

            var value = request.Body;
            var loginReq = JsonHelper.Deserialize<LoginRequest>(value);
            if (loginReq == null)
            {
                var errorResponse = JsonHelper.MakeJsonResponse(session.Response, new { error = "Request body invalid." }, 400);
                session.SendResponseAsync(errorResponse);
                return;
            }

            // TODO: kiểm tra username/password ở đây, ví dụ:
            // if (!CheckLogin(loginReq.username, loginReq.password)) { ... }

            // Đăng nhập thành công:
            int userId = CheckAccount(loginReq.username, loginReq.password);
            if (userId > 0)
            {
                var response = NewUserSession(userId, session.Response);

                session.SendResponseAsync(response); // gửi response

                return;
            }

            session.SendResponseAsync(session.Response.MakeErrorResponse(400, "Username or password incorrect"));

        }

    }
}
