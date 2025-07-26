using System.Text.Json;

namespace Server.Source.Helper
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
    }
}
