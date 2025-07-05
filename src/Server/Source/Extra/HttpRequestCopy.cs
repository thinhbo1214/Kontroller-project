using Server.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Server.Source.Extra
{
    public class HttpRequestCopy : HttpRequest
    {
        private readonly string _urlCopy;
        private readonly string _methodCopy;
        private readonly string _protocolCopy;
        private readonly string _bodyCopy;
        private readonly long _bodyLengthCopy;
        private readonly List<(string, string)> _headersCopy;
        private readonly List<(string, string)> _cookiesCopy;

        public HttpRequestCopy(HttpRequest source) : base()
        {
            if (source == null)
            {
                throw new ArgumentNullException(nameof(source));
            }

            // Sao chép tất cả thuộc tính
            _urlCopy = source.Url ?? string.Empty;
            _methodCopy = source.Method ?? string.Empty;
            _protocolCopy = source.Protocol ?? string.Empty;
            _bodyCopy = source.Body ?? string.Empty;
            _bodyLengthCopy = source.BodyLength;
            _headersCopy = new List<(string, string)>();
            _cookiesCopy = new List<(string, string)>();

            // Sao chép Headers
            for (int i = 0; i < source.Headers; i++)
            {
                _headersCopy.Add(source.Header(i));
            }

            // Sao chép Cookies
            for (int i = 0; i < source.Cookies; i++)
            {
                _cookiesCopy.Add(source.Cookie(i));
            }

            // Khởi tạo trạng thái lớp cha để tương thích
            SetBegin(_methodCopy, _urlCopy, _protocolCopy);
            foreach (var header in _headersCopy)
            {
                SetHeader(header.Item1, header.Item2);
            }
            foreach (var cookie in _cookiesCopy)
            {
                SetCookie(cookie.Item1, cookie.Item2);
            }
            SetBody(_bodyCopy);
        }

        // Ghi đè getter để trả về bản sao độc lập
        public new string Url => _urlCopy;
        public new string Method => _methodCopy;
        public new string Protocol => _protocolCopy;
        public new string Body => _bodyCopy;
        public new long BodyLength => _bodyLengthCopy;
        public new long Headers => _headersCopy.Count;
        public new long Cookies => _cookiesCopy.Count;

        public new (string, string) Header(int i)
        {
            if (i < 0 || i >= _headersCopy.Count)
            {
                return ("", "");
            }
            return _headersCopy[i];
        }

        public new (string, string) Cookie(int i)
        {
            if (i < 0 || i >= _cookiesCopy.Count)
            {
                return ("", "");
            }
            return _cookiesCopy[i];
        }

        // Ghi đè ToString để sử dụng dữ liệu sao chép
        public override string ToString()
        {
            var sb = new StringBuilder();
            sb.AppendLine($"Request method: {Method}");
            sb.AppendLine($"Request URL: {Url}");
            sb.AppendLine($"Request protocol: {Protocol}");
            sb.AppendLine($"Request headers: {Headers}");
            foreach (var header in _headersCopy)
            {
                sb.AppendLine($"{header.Item1} : {header.Item2}");
            }
            sb.AppendLine($"Request body: {BodyLength}");
            sb.AppendLine(Body);
            return sb.ToString();
        }
    }
}
