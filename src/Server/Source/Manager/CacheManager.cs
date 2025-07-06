using Server.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace Server.Source.Manager
{
    public class CacheManager
    {
        private readonly FileCache _fileCache = new FileCache();

        /// <summary>
        /// Cache một object bất kỳ dưới dạng JSON
        /// </summary>
        public bool Set<T>(string key, T obj, TimeSpan? timeout = null)
        {
            try
            {
                string json = JsonConvert.SerializeObject(obj);
                byte[] bytes = Encoding.UTF8.GetBytes(json);
                return _fileCache.Add(key, bytes, timeout ?? TimeSpan.Zero);
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Lấy object đã lưu từ cache và chuyển thành kiểu T
        /// </summary>
        public (bool found, T result) Get<T>(string key)
        {
            var (found, bytes) = _fileCache.Find(key);
            if (!found) return (false, default);

            try
            {
                string json = Encoding.UTF8.GetString(bytes);
                T obj = JsonConvert.DeserializeObject<T>(json);
                return (true, obj);
            }
            catch
            {
                return (false, default);
            }
        }

        /// <summary>
        /// Lấy chuỗi JSON từ cache (nếu không cần deserialize)
        /// </summary>
        public (bool found, string json) GetJson(string key)
        {
            var (found, bytes) = _fileCache.Find(key);
            if (!found) return (false, null);

            try
            {
                string json = Encoding.UTF8.GetString(bytes);
                return (true, json);
            }
            catch
            {
                return (false, null);
            }
        }

        /// <summary>
        /// Gỡ bỏ key khỏi cache
        /// </summary>
        public bool Remove(string key)
        {
            return _fileCache.Remove(key);
        }

        /// <summary>
        /// Tải dữ liệu từ thư mục vào cache theo dõi
        /// </summary>
        public bool LoadPath(string path, string prefix = "/", string filter = "*.*", TimeSpan? timeout = null)
        {
            return _fileCache.InsertPath(path, prefix, filter, timeout ?? TimeSpan.Zero);
        }

        /// <summary>
        /// Xoá toàn bộ cache
        /// </summary>
        public void Clear()
        {
            _fileCache.Clear();
        }

    }
}
/*
✅ Cách sử dụng: 
📝 Lưu một object:
var user = new { Id = 1, Name = "Thuận" };
cacheManager.Set("/user/1", user);
 
📤 Gửi dưới dạng byte[]
var (found, json) = cacheManager.GetJson("/user/1");
if (found)
{
    byte[] data = Encoding.UTF8.GetBytes(json);
    Send(data); // hoặc HTTP stream.Write(data)
}
 
📥 Đọc lại và chuyển thành object
var (found, userObj) = cacheManager.Get<YourUserClass>("/user/1");
if (found)
{
    Console.WriteLine(userObj.Name);
}
   
🧹 Dọn sạch cache
cacheManager.Clear();

 */