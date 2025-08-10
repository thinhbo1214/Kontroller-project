using Server.Source.Core;
using Server.Source.Extra;
using Server.Source.Manager;
using Server.Source.Model;
using Server.Source.NetCoreServer;
using System.Drawing;
using System.IO;    
using System.Net.Mime;
    

namespace Server.Source.Helper
{
    public static class FileHelper
    {
        public static void EnsureDirectory(string path)
        {
            if (!Directory.Exists(path))
                Directory.CreateDirectory(path);
        }

        public static void SaveFile(string directory, string fileName, byte[] content)
        {
            EnsureDirectory(directory);
            string filePath = Path.Combine(directory, fileName);
            File.WriteAllBytes(filePath, content);
        }
        public static (bool, string, string) SaveImageRequest(HttpRequest request, string saveDir, string newFileName)
        {
            // Parse multipart/form-data
            var files = MultipartHelper.ParseFiles(request);

            if (files.Count == 0)
            {
                return (false, null, "Không tìm thấy file upload!");
            }

            var file = files.FirstOrDefault(f => f.Name == saveDir);
            if (file == null)
            {
                return (false, null, $"Không tìm thấy file {saveDir}!");
            }

            // Validate ảnh
            var (isValid, extension, error) = ImageFileHelper.Validate(file);
            if (!isValid)
            {
                return (false, null, error);
            }

            // Lưu file
            saveDir = Path.Combine(Simulation.GetModel<ModelServer>().WWW, saveDir);
            newFileName = $"{newFileName}{extension}";
            SaveFile(saveDir, newFileName, file.Content);

            return (true, extension, null);
        }
    }

}
