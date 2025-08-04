namespace Server.Source.Helper
{
    /// <summary>
    /// Cung cấp các phương thức hỗ trợ giải mã và trích xuất tham số từ URL.
    /// </summary>
    public static class DecodeHelper
    {
        /// <summary>
        /// Phân tích URL và trả về các cặp tham số truy vấn dưới dạng Dictionary.
        /// </summary>
        /// <param name="path">Chuỗi URL chứa tham số truy vấn (query string).</param>
        /// <returns>Từ điển chứa các cặp khóa-giá trị tham số.</returns>
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

        /// <summary>
        /// Lấy giá trị của một tham số cụ thể từ URL.
        /// </summary>
        /// <param name="key">Tên tham số cần lấy giá trị.</param>
        /// <param name="url">Chuỗi URL chứa tham số.</param>
        /// <returns>Giá trị của tham số nếu tồn tại, ngược lại là null.</returns>
        public static string GetParamWithURL(string key, string url)
        {
            return ParseQueryParams(url).GetValueOrDefault(key);
        }
    }
}
