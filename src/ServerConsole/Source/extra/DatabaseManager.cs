using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerConsole.Source.extra
{
    class DatabaseManager
    {
        private static readonly string _basePath = "D:/MyServerData"; // nơi chứa file gốc

        public static bool TryGetFile(string key, out string content)
        {
            string path = GetFilePath(key);
            if (File.Exists(path))
            {
                content = File.ReadAllText(path);
                return true;
            }
            content = null;
            return false;
        }

        public static void SaveFile(string key, string content)
        {
            string path = GetFilePath(key);
            Directory.CreateDirectory(Path.GetDirectoryName(path)!);
            File.WriteAllText(path, content);
        }

        public static bool DeleteFile(string key, out string content)
        {
            string path = GetFilePath(key);
            if (File.Exists(path))
            {
                content = File.ReadAllText(path);
                File.Delete(path);
                return true;
            }
            content = null;
            return false;
        }

        private static string GetFilePath(string key)
        {
            // Ánh xạ key thành path thật (có thể hash hoặc giữ nguyên)
            string safeKey = key.Replace("/", "_"); // tránh path traversal
            return Path.Combine(_basePath, $"{safeKey}.txt");
        }

    }
}
