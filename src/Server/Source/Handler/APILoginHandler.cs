using Azure;
using Microsoft.VisualBasic.ApplicationServices;
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
            string? oldSessionId = CookieHelper.GetSession(request); // lấy sessionId cũ

            var sessionManager = Simulation.GetModel<SessionManager>();

            if (oldSessionId != null)
            {
                session.SendResponseAsync(session.Response.MakeOkResponse());
                return;
            }    

            var value = request.Body;
            if (string.IsNullOrEmpty(value))
            {
                var errorResponse = JsonHelper.MakeJsonResponse(session.Response, new { error = "Request body is empty." }, 400);
                session.SendResponseAsync(errorResponse);
                return;
            }

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

                var response = JsonHelper.MakeJsonResponse(session.Response, new { message = "Login success", userId = 123 }); // tạo response
                CookieHelper.SetSession(response, newSessionId); // set cookie
                Simulation.GetModel<LogManager>().Log(response.ToString()); // báo log


                session.SendResponseAsync(response); // gửi response

                Simulation.GetModel<LogManager>().Log($"Login success, sessionId = {newSessionId}"); // báo log
                return;
            }

            session.SendResponseAsync(session.Response.MakeErrorResponse(400, "Username or password incorrect"));

        }

    }
}
