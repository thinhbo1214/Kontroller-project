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

        public override void Handle(HttpRequest request, HttpsSession session)
        {
            string? oldToken = TokenHelper.GetToken(request); // lấy token từ request
            var sessionManager = Simulation.GetModel<SessionManager>();

            if (sessionManager.Authorization(request, out int userId, session))
            {
                var response = JsonHelper.MakeJsonResponse(session.Response, new { message = "Login success", userId = userId }); // tạo response
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
            if (loginReq.username == "admin" && loginReq.password == "admin")
            {
                string newSessionId = Guid.NewGuid().ToString(); // sessionId mới
                sessionManager.Store(newSessionId, 123);         // lưu phiên

                var token = TokenHelper.CreateToken(newSessionId, 60); // tạo token
                var response = JsonHelper.MakeJsonResponse(session.Response, new { message = "Login success", userId = 123 }, 200, token); // tạo response

                Simulation.GetModel<LogManager>().Log(response.ToString()); // báo log

                session.SendResponseAsync(response); // gửi response

                Simulation.GetModel<LogManager>().Log($"Login success, sessionId = {newSessionId}"); // báo log
                return;
            }

            session.SendResponseAsync(session.Response.MakeErrorResponse(400, "Username or password incorrect"));

        }

    }
}
