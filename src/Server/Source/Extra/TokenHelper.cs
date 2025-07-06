using Server.Source.Core;
using Server.Source.Manager;
using Server.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Server.Source.Extra
{
    public static class TokenHelper
    {
        public static string CreateToken(string sessionId, int minutes)
        {
            var expire = DateTimeOffset.UtcNow.AddMinutes(minutes).ToUnixTimeSeconds();
            var payload = $"{sessionId}:{expire}";
            return Convert.ToBase64String(Encoding.UTF8.GetBytes(payload));
        }
        public static bool TryParseToken(string token, out string sessionId)
        {
            sessionId = "";
            try
            {
                var raw = Encoding.UTF8.GetString(Convert.FromBase64String(token));
                var parts = raw.Split(':');
                if (parts.Length != 2) return false;

                sessionId = parts[0];
                var expireUnix = long.Parse(parts[1]);
                var expireTime = DateTimeOffset.FromUnixTimeSeconds(expireUnix).UtcDateTime;

                return DateTime.UtcNow <= expireTime;
            }
            catch
            {
                return false;
            }
        }

        public static void SetToken(HttpResponse response, string sessionId, int minutes = 60)
        {
            response.SetHeader("X_Token_Authorization", $"{TokenHelper.CreateToken(sessionId, minutes)}");
        }

        public static void RemoveToken(HttpResponse response)
        {
            response.SetHeader("X_Token_Authorization", "");
        }

        public static string? GetToken(HttpRequest request)
        {
            for (int i = 0; i < request.Headers; i++)
            {
                var (key, value) = request.Header(i);
                if (key == "X_Token_Authorization")
                    return value;
            }
            return null;
        }
    }

}
