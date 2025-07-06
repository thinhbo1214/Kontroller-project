using Microsoft.IdentityModel.Tokens;
using Server.Source.NetCoreServer;
using System;
using System.Text.Json;

namespace Server.Source.Extra
{
    public static class JsonHelper
    {
        /// <summary>
        /// Chuyển object thành JSON string để gửi response.
        /// </summary>
        public static string Serialize(object obj)
        {
            return JsonSerializer.Serialize(obj);
        }

        /// <summary>
        /// Parse JSON string từ request thành object kiểu T.
        /// Trả về null nếu lỗi format hoặc không parse được.
        /// </summary>
        public static T? Deserialize<T>(string json)
        {
            try
            {
                return JsonSerializer.Deserialize<T>(json);
            }
            catch (JsonException)
            {
                // Có thể log lỗi ở đây nếu cần
                return default;
            }
        }
        public static HttpResponse MakeJsonResponse(this HttpResponse response, object data, int status = 200, string token ="")
        {
            response.SetBegin(status);

            //response.SetHeader("Access-Control-Expose-Headers", "X_Token_Authorization");
            //response.SetHeader("X_Token_Authorization", $"{TokenHelper.CreateToken(Guid.NewGuid().ToString(), 60)}");
            if (!token.IsNullOrEmpty())
            {
                response.SetHeader("Access-Control-Expose-Headers", "X_Token_Authorization");
                response.SetHeader("X_Token_Authorization", $"{token}");
            }

            response.SetContentType(".json");
            response.SetBody(JsonHelper.Serialize(data));
            return response;
        }
    }
}
