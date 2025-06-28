using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.Json;
using ServerConsole.Source.NetCoreServer;
using ServerConsole.Source.Core;
using ServerConsole.Source.Event;
using ServerConsole.Source.Extra;

namespace ServerConsole.Source.Handler
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

            var value = request.Body;
            if (string.IsNullOrEmpty(value))
            {
                // Xử lý khi body rỗng hoặc null
                Console.WriteLine("Request body is empty.");
                session.SendResponseAsync(session.Response.MakeErrorResponse(400, "Request body is empty."));
            }
            else
            {
                LoginRequest? loginReq = JsonSerializer.Deserialize<LoginRequest>(value);
                if (loginReq == null)
                {
                    // Xử lý khi deserialize thất bại
                    Console.WriteLine("Deserialize JSON failed.");
                    // Có thể trả về lỗi HTTP hoặc xử lý khác
                    return;
                }
                // Xử lý tiếp với loginReq đã chắc chắn không null
                Console.WriteLine($"Username: {loginReq.username}");

                Console.WriteLine($"Password: {loginReq.password}");
                Console.WriteLine("Login successfully");
                session.SendResponseAsync(session.Response.MakeOkResponse());
            }
        }

    }
}
