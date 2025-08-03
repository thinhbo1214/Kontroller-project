using Microsoft.IdentityModel.Tokens;
using Server.Source.Core;
using Server.Source.Manager;
using Server.Source.NetCoreServer;

namespace Server.Source.Helper
{
    public static class ResponseHelper
    {
        public static HttpResponse MakeJsonResponse(this HttpResponse response, int status = 200, string token = "")
        {
            switch (status)
            {
                case 200:
                    return response.MakeJsonResponse(new { success = true, message = "OK" }, status, token);
                case 201:
                    return response.MakeJsonResponse(new { success = true, message = "Resource created successfully" }, status, token);
                case 400:
                    return response.MakeJsonResponse(new { success = false, message = "Invalid request" }, status, token);
                case 401:
                    return response.MakeJsonResponse(new { success = false, message = "Authentication required" }, status, token);
                case 404:
                    return response.MakeJsonResponse(new { success = false, message = "Not Found" }, status, token);
                case 500:
                    return response.MakeJsonResponse(new { success = false, message = "Internal server error" }, status, token);
                default:
                    return response.MakeJsonResponse(null, status, token);
            }
        }
        public static HttpResponse MakeJsonResponse(this HttpResponse response, object? data, int status = 200, string token = "")
        {
            response.SetBegin(status);

            if (!token.IsNullOrEmpty())
            {
                response.SetHeader("Access-Control-Expose-Headers", "X_Token_Authorization");
                response.SetHeader("X_Token_Authorization", $"{token}");
            }

            response.SetContentType(".json");
            if (data != null)
            {
                response.SetBody(JsonHelper.Serialize(data));
            }
            return response;
        }

        public static HttpResponse NewUserSession(string userId, HttpResponse response)
        {
            string newSessionId = Guid.NewGuid().ToString(); // sessionId mới
            Simulation.GetModel<SessionManager>().Store(newSessionId, userId);         // lưu phiên

            var token = TokenHelper.CreateToken(newSessionId, 60); // tạo token
            response = response.MakeJsonResponse(200, token);

            return response;
        }

    }
}
