using Server.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Server.Source.Extra
{
    public static class CookieHelper
    {
        public static void SetSession(HttpResponse response, string sessionId, int minutes = 60)
        {
            response.SetCookie("sessionId", sessionId, maxAge: minutes * 60, path: "/", secure: true, strict: true, httpOnly: true);
        }

        public static void RemoveSession(HttpResponse response)
        {
            response.SetCookie("sessionId", "", maxAge: 0, path: "/", secure: true, strict: true, httpOnly: true);
        }

        public static string? GetSession(HttpRequest request)
        {
            for (int i = 0; i < request.Cookies; i++)
            {
                var (key, value) = request.Cookie(i);
                if (key == "sessionId")
                    return value;
            }
            return null;
        }
    }

}
