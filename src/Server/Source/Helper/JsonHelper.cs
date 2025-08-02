using System.Text.Json;
using System.Text.Json.Serialization;

namespace Server.Source.Helper
{
    public static class JsonHelper
    {
        /// <summary>
        /// Chuyển object thành JSON string để gửi response.
        /// </summary>
        public static string Serialize(object obj)
        {
            var options = new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true,
                DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull
            };

            return JsonSerializer.Serialize(obj, options);
        }

        /// <summary>
        /// Parse JSON string từ request thành object kiểu T.
        /// Trả về null nếu lỗi format hoặc không parse được.
        /// </summary>
        public static T? Deserialize<T>(string json)
        {
            try
            {
                var options = new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true,
                    AllowTrailingCommas = true, // Cho phép dấu phẩy thừa
                    ReadCommentHandling = JsonCommentHandling.Skip // Bỏ qua comment trong JSON
                };
                return JsonSerializer.Deserialize<T>(json, options);
            }
            catch (JsonException)
            {
                // Có thể log lỗi ở đây nếu cần
                return default;
            }
        }  
    }
}
