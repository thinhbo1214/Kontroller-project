using Server.Source.Core;
using Server.Source.Extra;
using Server.Source.Manager;
using Server.Source.NetCoreServer;
using System.Text;

namespace Server.Source.Helper
{
    public static class MultipartHelper
    {
        public static string GetHeader(HttpRequest request, string name)
        {
            for (int i = 0; i < request.Headers; i++)
            {
                var (key, value) = request.Header(i);
                if (key.Equals(name, StringComparison.OrdinalIgnoreCase))
                    return value;
            }
            return null;
        }
        public static List<UploadedFile> ParseFiles(HttpRequest request)
        {
            var files = new List<UploadedFile>();

            // Lấy Content-Type
            var contentType = GetHeader(request, "Content-Type");
            if (string.IsNullOrEmpty(contentType) || !contentType.StartsWith("multipart/form-data", StringComparison.OrdinalIgnoreCase))
                return files;

            // Lấy boundary
            var boundaryIndex = contentType.IndexOf("boundary=", StringComparison.OrdinalIgnoreCase);
            if (boundaryIndex < 0) return files;
            var boundary = "--" + contentType.Substring(boundaryIndex + 9);
            var boundaryBytes = Encoding.UTF8.GetBytes(boundary);

            var bodyBytes = request.BodyBytes;

            // Tìm các vị trí boundary
            int pos = 0;
            while (pos < bodyBytes.Length)
            {
                // Tìm boundary tiếp theo
                int boundaryPos = IndexOf(bodyBytes, boundaryBytes, pos);
                if (boundaryPos < 0) break;

                pos = boundaryPos + boundaryBytes.Length;

                // Nếu là boundary kết thúc thì dừng
                if (pos + 2 <= bodyBytes.Length && bodyBytes[pos] == '-' && bodyBytes[pos + 1] == '-')
                    break;

                // Bỏ qua CRLF
                if (pos + 2 <= bodyBytes.Length && bodyBytes[pos] == '\r' && bodyBytes[pos + 1] == '\n')
                    pos += 2;

                // Tìm header end (\r\n\r\n)
                int headerEnd = IndexOf(bodyBytes, Encoding.UTF8.GetBytes("\r\n\r\n"), pos);
                if (headerEnd < 0) break;

                // Parse header
                var headerStr = Encoding.UTF8.GetString(bodyBytes, pos, headerEnd - pos);
                pos = headerEnd + 4;

                string name = null;
                string fileName = null;
                string partContentType = null;

                foreach (var line in headerStr.Split(new[] { "\r\n" }, StringSplitOptions.RemoveEmptyEntries))
                {
                    if (line.StartsWith("Content-Disposition", StringComparison.OrdinalIgnoreCase))
                    {

                        // Lấy name=
                        var nameIndex = line.IndexOf("name=\"", StringComparison.OrdinalIgnoreCase);
                        if (nameIndex >= 0)
                        {
                            var namePart = line.Substring(nameIndex + 6);
                            var quoteIndex = namePart.IndexOf('"');
                            if (quoteIndex >= 0)
                                namePart = namePart.Substring(0, quoteIndex);
                            name = namePart;
                        }

                        // Lấy filename=
                        var fnIndex = line.IndexOf("filename=\"", StringComparison.OrdinalIgnoreCase);
                        if (fnIndex >= 0)
                        {
                            fileName = line.Substring(fnIndex + 10);
                            var quoteIndex = fileName.IndexOf('"');
                            if (quoteIndex >= 0)
                                fileName = fileName.Substring(0, quoteIndex);
                        }
                    }
                    else if (line.StartsWith("Content-Type", StringComparison.OrdinalIgnoreCase))
                    {
                        partContentType = line.Split(':')[1].Trim();
                    }
                }

                if (string.IsNullOrEmpty(fileName))
                {
                    // Không phải file => bỏ qua
                    // Tìm boundary tiếp theo
                    pos = SkipToNextBoundary(bodyBytes, boundaryBytes, pos);
                    continue;
                }

                // Tìm boundary kế tiếp
                int nextBoundaryPos = IndexOf(bodyBytes, boundaryBytes, pos);
                if (nextBoundaryPos < 0) break;

                // Lấy dữ liệu file (bỏ CRLF cuối)
                int contentLength = nextBoundaryPos - pos;
                if (contentLength >= 2 && bodyBytes[nextBoundaryPos - 2] == '\r' && bodyBytes[nextBoundaryPos - 1] == '\n')
                    contentLength -= 2;

                var fileData = new byte[contentLength];
                Array.Copy(bodyBytes, pos, fileData, 0, contentLength);

                files.Add(new UploadedFile
                {
                    Name = name,
                    FileName = fileName,
                    ContentType = partContentType,
                    Content = fileData
                });
                Simulation.GetModel<LogManager>().Log($"Parsed file: Name={name}, FileName={fileName}, Size={fileData.Length}, FirstBytes={BitConverter.ToString(fileData, 0, Math.Min(fileData.Length, 16))}");
                pos = nextBoundaryPos;
            }

            return files;
        }

        private static int IndexOf(byte[] haystack, byte[] needle, int startIndex)
        {
            for (int i = startIndex; i <= haystack.Length - needle.Length; i++)
            {
                bool found = true;
                for (int j = 0; j < needle.Length; j++)
                {
                    if (haystack[i + j] != needle[j])
                    {
                        found = false;
                        break;
                    }
                }
                if (found) return i;
            }
            return -1;
        }

        private static int SkipToNextBoundary(byte[] body, byte[] boundary, int startIndex)
        {
            int pos = IndexOf(body, boundary, startIndex);
            return pos >= 0 ? pos : body.Length;
        }
    }
}
