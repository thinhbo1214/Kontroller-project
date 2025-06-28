using ServerConsole.Source.Extra;
using ServerConsole.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using static ServerConsole.Source.Handler.APILoginHandler;

namespace ServerConsole.Source.Handler
{
    internal class APISignupHandler : HandlerBase
    {
        public class SignupRequest
        {
            public string username { get; set; }
            public string password { get; set; }
            public SignupRequest()
            {
                username = "";
                password = "";
            }
        }
        public override string Type => "/api/signup";
        public override void Handle(HttpRequest request, HttpsSession session)
        {
            var value = request.Body;
            if (string.IsNullOrEmpty(value))
            {
                session.SendResponseAsync(session.Response.MakeErrorResponse(400, "Request body is empty."));
                return;
            }

            SignupRequest? signupReq = JsonSerializer.Deserialize<SignupRequest>(value);

            if (signupReq == null)
            {
                // Xử lý khi deserialize thất bại
                Console.WriteLine("Deserialize JSON failed.");
                // Có thể trả về lỗi HTTP hoặc xử lý khác
                return;
            }
            Console.WriteLine($"Username: {signupReq.username}");
            Console.WriteLine($"Password: {signupReq.password}");
            Console.WriteLine("Signup successfully");
            session.SendResponseAsync(session.Response.MakeOkResponse());
        }
    }
}
