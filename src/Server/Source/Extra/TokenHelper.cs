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
        private static Dictionary<TokeType, string> types;
        static TokenHelper()
        {
            types = new Dictionary<TokeType, string>
            {
                {TokeType.X_Token_Authorization, "X_Token_Authorization"},
            };
        }

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
            response.SetHeader(types[TokeType.X_Token_Authorization], CreateToken(sessionId, minutes));
        }

        public static void RemoveToken(HttpResponse response)
        {
            response.SetHeader(types[TokeType.X_Token_Authorization], "");
        }

        public static string? GetToken(HttpRequest request)
        {
            for (int i = 0; i < request.Headers; i++)
            {
                var (key, value) = request.Header(i);
                if (key == types[TokeType.X_Token_Authorization])
                    return value;
            }
            return null;
        }
    }

    public enum TokeType
    {
        /// <summary>Thông tin chung</summary>
        X_Token_Authorization,
    }

}
