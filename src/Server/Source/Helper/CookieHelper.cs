﻿using Server.Source.NetCoreServer;

namespace Server.Source.Helper
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
            if (request.Cookies > 0)
            {
                for (int i = 0; i < request.Cookies; i++)
                {
                    var (key, value) = request.Cookie(i);
                    if (key == "sessionId")
                        return value;
                }
            }
            return null;
        }
    }

}
