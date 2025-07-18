using System;
using System.Collections.Concurrent;
using System.IO;
using System.Threading;
using System.Threading.Tasks;
using Server.Source.Core;

namespace Server.Source.Manager
{
    /// <summary>
    /// LogManager là hệ thống ghi log chạy nền, đảm bảo thread-safe.
    /// Ghi log ra file theo ngày và cung cấp sự kiện OnLogPrinted để các lớp khác hiển thị log.
    /// </summary>
    public class LogManager
    {
        /// <summary>
        /// Hàng đợi log an toàn đa luồng để lưu trữ log chờ ghi.
        /// </summary>
        private readonly BlockingCollection<(LogSource source, string message)> _logQueue = new();

        /// <summary>
        /// Bộ điều khiển tín hiệu hủy để dừng task ghi log một cách an toàn.
        /// </summary>
        private CancellationTokenSource _cts = new();

        /// <summary>
        /// Task xử lý ghi log nền.
        /// </summary>
        private Task? _logTask;

        /// <summary>
        /// Sự kiện phát ra mỗi khi có log mới, để lớp View/UI có thể lắng nghe và hiển thị.
        /// </summary>
        public event Action<LogSource, string> OnLogPrinted;

        /// <summary>
        /// Đường dẫn file log hiện tại, theo ngày.
        /// </summary>
        private string _logUserFilePath;
        private string _logSystemFilePath;

        /// <summary>
        /// Định dạng log chung
        /// </summary>
        /// <param name="message"></param>
        /// <param name="level"></param>
        /// <returns></returns>
        private string FormatLog(string message, LogLevel level)
            => $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] [{level}] {message}";

        /// <summary>
        /// Thêm log mới vào hàng đợi. Không ghi ngay mà để task nền xử lý.
        /// </summary>
        /// <param name="message">Nội dung log</param>
        /// <param name="level">Mức độ log: INFO, WARN, ERROR, DEBUG</param>
        public void Log(string message, LogLevel level = LogLevel.INFO, LogSource source = LogSource.USER)
        {
            var logEntry = FormatLog(message, level);
            _logQueue.Add((source, logEntry)); // Lưu cả source và message đã format
        }

        /// <summary>
        /// Log cho ngoại lệ hệ thống
        /// </summary>
        /// <param name="ex"></param>
        /// <param name="level"></param>
        public void Log(Exception ex, LogLevel level = LogLevel.ERROR, LogSource source = LogSource.SYSTEM)
            => Log(ex.ToString(), level, source);

        /// <summary>
        /// Khởi chạy log trong nền (tự động).
        /// </summary>
        public void Start()
        {
            if (_logTask != null && !_logTask.IsCompleted)
                return; // đã chạy rồi

            if (_cts.IsCancellationRequested)
                _cts = new CancellationTokenSource(); // Reset token nếu đã huỷ trước đó

            // Tạo thư mục 'logs' nếu chưa tồn tại
            var logDir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "logs");
            var log_user = Path.Combine(logDir, "log_user");
            var log_system = Path.Combine(logDir, "log_system");
            Directory.CreateDirectory(logDir);
            Directory.CreateDirectory(log_user);
            Directory.CreateDirectory(log_system);


            // Tạo file log tên theo ngày, ví dụ: logs/log_2025-06-27.txt
            var date = DateTime.Now.ToString("yyyy-MM-dd");
            _logUserFilePath = Path.Combine(log_user, $"log_{date}.txt");
            _logSystemFilePath = Path.Combine(log_system, $"log_{date}.txt");

            // Khởi chạy task xử lý log chạy nền
            _logTask = Task.Run(() => Run(_cts.Token));
        }

        /// <summary>
        /// Restart component
        /// </summary>
        public void Restart()
        {
            Stop();
            Start();
        }

        /// <summary>
        /// Gửi tín hiệu dừng hệ thống log, đóng hàng đợi và đợi task nền hoàn tất.
        /// </summary>
        public void Stop()
        {
            _cts.Cancel(); // Gửi tín hiệu yêu cầu dừng cho vòng lặp
            Simulation.GetModel<LogManager>().Log("LogManager stopped.", LogLevel.INFO, LogSource.SYSTEM);
            _logQueue.CompleteAdding(); // Không cho thêm log mới
            try
            {
                _logTask.Wait(); // Đợi cho task kết thúc hoàn toàn
            }
            catch (AggregateException ae)
            {
                // Bỏ qua ngoại lệ hợp lệ (ví dụ do Cancel)
                ae.Handle(e => e is OperationCanceledException);
            }
        }

        /// <summary>
        /// Vòng lặp xử lý log chạy nền: lấy log từ hàng đợi, ghi ra file, phát sự kiện.
        /// </summary>
        /// <param name="token">CancellationToken để dừng an toàn</param>
        private async Task Run(CancellationToken token)
        {
            var currentDate = DateTime.Now.Date;
            StreamWriter writerU = null;
            StreamWriter writerS = null;
            while (!token.IsCancellationRequested)
            {
                try
                {
                    //if (DateTime.Now.Date != currentDate)
                    //{
                    //    currentDate = DateTime.Now.Date;
                    //    _logFilePath = ...; // tạo file mới theo ngày
                    //    continue;
                    //}

                    // Mỗi lần có lỗi sẽ mở lại writer để tránh lỗi writer bị đóng hoặc bị khóa
                    writerU = new StreamWriter(_logUserFilePath, true) { AutoFlush = true };
                    writerS = new StreamWriter(_logSystemFilePath, true) { AutoFlush = true };

                    // Ghi log cho đến khi bị huỷ hoặc CompleteAdding()
                    foreach (var (source, log) in _logQueue.GetConsumingEnumerable(token))
                    {
                        // Nếu bị huỷ giữa chừng
                        if (token.IsCancellationRequested) break;

                        // Gửi log cho UI
                        OnLogPrinted?.Invoke(source, log);

                        // Ghi log ra file
                        if (source == LogSource.USER)
                        {
                            writerU.WriteLine(log);
                        }
                        else
                        {
                            writerS.WriteLine(log);
                        }


                    }

                    // Nếu ra khỏi foreach do CompleteAdding(), thì kết thúc luôn
                    break;
                }
                catch (OperationCanceledException)
                {
                    // Được phép dừng hợp lệ
                    break;
                }
                catch (Exception ex)
                {
                    // Ghi lỗi ra stderr và tiếp tục vòng while để thử lại
                    Log(ex);
                    await Task.Delay(1000, token);
                }
                finally
                {
                    writerU?.Dispose();
                    writerS?.Dispose();
                }
            }
        }

    }
    /// <summary>
    /// Các mức độ log được hỗ trợ bởi LogManager.
    /// </summary>
    public enum LogLevel
    {
        /// <summary>Thông tin chung</summary>
        INFO,
        /// <summary>Cảnh báo có thể ảnh hưởng</summary>
        WARN,
        /// <summary>Lỗi nghiêm trọng cần xử lý</summary>
        ERROR,
        /// <summary>Thông tin chi tiết phục vụ debug</summary>
        DEBUG
    }
    public enum LogSource
    {
        USER,
        SYSTEM
    }
}
