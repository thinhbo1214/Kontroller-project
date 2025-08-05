using System.Collections.Concurrent;
using System.Net;
using System.Net.Mail;
using Server.Source.Extra;

namespace Server.Source.Manager
{
    /// <summary>
    /// Quản lý hệ thống gửi email nền bằng SMTP, sử dụng hàng đợi và đa luồng an toàn.
    /// Cho phép cấu hình linh hoạt người gửi (smtpUser) cho từng email.
    /// </summary>
    public class NotifyManager
    {
        /// <summary>
        /// Hàng đợi các yêu cầu gửi email đang chờ xử lý.
        /// </summary>
        private readonly BlockingCollection<EmailSendRequest> _queue = new();

        /// <summary>
        /// Token hủy để điều khiển vòng đời của tác vụ gửi email.
        /// </summary>
        private CancellationTokenSource _cts = new();

        /// <summary>
        /// Tác vụ chạy nền để xử lý hàng đợi gửi email.
        /// </summary>
        private Task? _task;

        /// <summary>
        /// Máy chủ SMTP (ví dụ: smtp.gmail.com cho gmail).
        /// </summary>
        private readonly string _smtpHost;

        /// <summary>
        /// Cổng SMTP (ví dụ: 587 cho TLS).
        /// </summary>
        private readonly int _smtpPort;

        /// <summary>
        /// Mật khẩu ứng dụng (app password) dùng chung để xác thực SMTP. (ví dụ: aysd pgdv lfib ldll)
        /// </summary>
        private readonly string _smtpPass;

        /// <summary>
        /// Có sử dụng SSL/TLS cho kết nối SMTP hay không.
        /// </summary>
        private readonly bool _useSsl;

        /// <summary>
        /// Sự kiện được kích hoạt khi một email được gửi thành công.
        /// </summary>
        public event Action<EmailSendRequest>? OnEmailSent;

        /// <summary>
        /// Sự kiện được kích hoạt khi gửi email thất bại.
        /// </summary>
        public event Action<EmailSendRequest, Exception>? OnEmailFailed;

        /// <summary>
        /// Khởi tạo đối tượng NotifyManager với thông tin cấu hình SMTP.
        /// </summary>
        /// <param name="smtpHost">Địa chỉ máy chủ SMTP.</param>
        /// <param name="smtpPort">Cổng SMTP.</param>
        /// <param name="smtpPass">Mật khẩu ứng dụng (SMTP password).</param>
        /// <param name="useSsl">Sử dụng SSL/TLS hay không.</param>
        public NotifyManager(string smtpHost, int smtpPort, string smtpPass, bool useSsl = true)
        {
            _smtpHost = smtpHost;
            _smtpPort = smtpPort;
            _smtpPass = smtpPass;
            _useSsl = useSsl;
        }

        /// <summary>
        /// Bắt đầu hệ thống gửi email nền.
        /// Nếu đang chạy thì sẽ không làm gì.
        /// </summary>
        public void Start()
        {
            if (_task != null && !_task.IsCompleted) return;
            if (_cts.IsCancellationRequested) _cts = new CancellationTokenSource();
            _task = Task.Run(() => Run(_cts.Token));
        }

        /// <summary>
        /// Dừng hệ thống gửi email nền.
        /// Đóng hàng đợi và đợi tác vụ hoàn tất.
        /// </summary>
        public void Stop()
        {
            _cts.Cancel();
            _queue.CompleteAdding();

            try
            {
                _task?.Wait();
            }
            catch (AggregateException ae)
            {
                ae.Handle(e => e is OperationCanceledException);
            }
        }

        /// <summary>
        /// Thêm một yêu cầu gửi email vào hàng đợi.
        /// </summary>
        /// <param name="request">Thông tin email cần gửi.</param>
        public void Send(EmailSendRequest request)
        {
            _queue.Add(request);
        }

        /// <summary>
        /// Vòng lặp chính xử lý gửi email nền.
        /// Lấy email từ hàng đợi, gửi qua SMTP và phát sự kiện tương ứng.
        /// </summary>
        /// <param name="token">Token để hủy tác vụ một cách an toàn.</param>
        private async Task Run(CancellationToken token)
        {
            foreach (var req in _queue.GetConsumingEnumerable(token))
            {
                if (token.IsCancellationRequested) break;

                using var message = new MailMessage();
                message.From = new MailAddress(req.FromEmail);
                message.To.Add(req.ToEmail);
                message.Subject = req.Subject;
                message.Body = req.Body;
                message.IsBodyHtml = req.IsHtml;

                foreach (var filePath in req.Attachments)
                {
                    if (File.Exists(filePath))
                    {
                        message.Attachments.Add(new Attachment(filePath));
                    }
                }

                using var client = new SmtpClient(_smtpHost, _smtpPort)
                {
                    EnableSsl = _useSsl,
                    Credentials = new NetworkCredential(req.SmtpUser, _smtpPass)
                };

                try
                {
                    await client.SendMailAsync(message);
                    OnEmailSent?.Invoke(req);
                }
                catch (Exception ex)
                {
                    OnEmailFailed?.Invoke(req, ex);
                }

                await Task.Delay(300, token); // Tránh spam server
            }
        }
    }
}

/*
 notifyManager.Send(new EmailSendRequest
{
    SmtpUser = "your_gmail@gmail.com",
    FromEmail = "your_gmail@gmail.com",
    ToEmail = "friend@example.com",
    Subject = "Gửi email có file đính kèm",
    Body = "Đây là email có file đính kèm.",
    IsHtml = false,
    Attachments = new List<string>
    {
        @"C:\Users\thuận\Documents\bao_cao.pdf",
        @"C:\Users\thuận\Pictures\anh.png"
    }
});
 
 */