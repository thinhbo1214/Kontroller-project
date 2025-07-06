using Server.Source.Core;
using Server.Source.Extra;
using Server.Source.Manager;
using Server.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using static Server.Source.Handler.APILoginHandler;

namespace Server.Source.Handler
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
                var errorResponse = JsonHelper.MakeJsonResponse(session.Response, new { error = "Request body is empty." }, 400);
                session.SendResponseAsync(errorResponse);
                return;
            }

            SignupRequest? signupReq = JsonHelper.Deserialize<SignupRequest>(value);

            if (signupReq == null)
            {
                // Xử lý khi deserialize thất bại
                var errorResponse = JsonHelper.MakeJsonResponse(session.Response, new { error = "Request body invalid." }, 400);
                session.SendResponseAsync(errorResponse);

                // Có thể trả về lỗi HTTP hoặc xử lý khác
                return;
            }
            // Giả sử đăng ký thành công
            var response = JsonHelper.MakeJsonResponse(session.Response, new { message = "Signup successful", username = signupReq.username });
            session.SendResponseAsync(response);

            Simulation.GetModel<LogManager>().Log($"Sigup success");
        }
    }
}
