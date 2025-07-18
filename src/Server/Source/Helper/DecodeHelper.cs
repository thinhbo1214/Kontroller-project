using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Server.Source.Helper
{
    public static class DecodeHelper
    {
        public static Dictionary<string, string> ParseQueryParams(string path)
        {
            var dict = new Dictionary<string, string>();
            var parts = path.Split('?', 2);
            if (parts.Length < 2) return dict;

            var query = parts[1];
            var pairs = query.Split('&', StringSplitOptions.RemoveEmptyEntries);
            foreach (var pair in pairs)
            {
                var kv = pair.Split('=', 2);
                var key = Uri.UnescapeDataString(kv[0]);
                var value = kv.Length > 1 ? Uri.UnescapeDataString(kv[1]) : "";
                dict[key] = value;
            }
            return dict;
        }
        public static string GetParamWithURL(string key, string url)
        {
            return ParseQueryParams(url).GetValueOrDefault(key);
        }
    }
}
