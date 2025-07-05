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
            string ip = (session.Socket.RemoteEndPoint as System.Net.IPEndPoint)?.Address.ToString() ?? "unknown";

            var sessionManager = Simulation.GetModel<SessionManager>();

            if (oldSessionId != null)
            {
                session.SendResponseAsync(session.Response.MakeOkResponse());
                return;
            }    

            var value = request.Body;
            if (string.IsNullOrEmpty(value))
            {
                session.SendResponseAsync(session.Response.MakeErrorResponse(400, "Request body is empty."));
                return;
            }

            var loginReq = JsonSerializer.Deserialize<LoginRequest>(value);
            if (loginReq == null)
            {
                session.SendResponseAsync(session.Response.MakeErrorResponse(400, "Request body invalid."));
                return;
            }

            // TODO: kiểm tra username/password ở đây, ví dụ:
            // if (!CheckLogin(loginReq.username, loginReq.password)) { ... }

            // Đăng nhập thành công:
            string newSessionId = Guid.NewGuid().ToString(); // sessionId mới
            sessionManager.Store(newSessionId, 123, ip);         // lưu phiên

            var response = session.Response.MakeOkResponse(); // phản hồi oke
            CookieHelper.SetSession(response, newSessionId); // set cookie

            session.SendResponseAsync(response);
        }

    }
}
