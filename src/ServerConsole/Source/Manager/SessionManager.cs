using ServerConsole.Source.Core;
using ServerConsole.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerConsole.Source.Manager
{
    public class SessionManager
    {
        private readonly ReaderWriterLockSlim _lock = new();
        private readonly Dictionary<string, SessionEntry> _sessions = new();

        /// <summary>
        /// Bộ điều khiển tín hiệu hủy để dừng task một cách an toàn.
        /// </summary>
        private CancellationTokenSource _cts = new();

        /// <summary>
        /// Task xử lý nền.
        /// </summary>
        private Task? _cleanerTask;

        private class SessionEntry
        {
            public int UserId;
            public DateTime ExpireAt;
            public string IpAddress = "";

            public bool IsExpired => DateTime.UtcNow > ExpireAt;
        }

        public void Store(string sessionId, int userId, string ipAddress, TimeSpan? ttl = null)
        {
            ttl ??= TimeSpan.FromHours(1);
            using (new WriteLock(_lock))
            {
                _sessions[sessionId] = new SessionEntry
                {
                    UserId = userId,
                    ExpireAt = DateTime.UtcNow + ttl.Value,
                    IpAddress = ipAddress
                };
            }
        }

        public int? GetUserId(string sessionId, string currentIp)
        {
            using (new ReadLock(_lock))
            {
                if (_sessions.TryGetValue(sessionId, out var entry))
                {
                    if (!entry.IsExpired)
                    {
                        if (entry.IpAddress == currentIp)
                            return entry.UserId;

                        Simulation.GetModel<LogManager>()?.Log($"Phiên đăng nhập của user {entry.UserId} đang bị truy cập từ IP khác. Gốc: {entry.IpAddress}, Hiện tại: {currentIp}", LogLevel.WARN);
                    }
                }
            }

            Remove(sessionId); // xoá nếu hết hạn hoặc IP sai
            return null;
        }

        public void Remove(string sessionId)
        {
            using (new WriteLock(_lock))
            {
                _sessions.Remove(sessionId);
            }
        }

        public void Clear()
        {
            using (new WriteLock(_lock)) _sessions.Clear();
        }

        public void CleanExpiredSessions()
        {
            using (new WriteLock(_lock))
            {
                var expired = _sessions
                    .Where(kv => kv.Value.ExpireAt <= DateTime.UtcNow)
                    .Select(kv => kv.Key)
                    .ToList(); // Tránh sửa collection khi đang duyệt

                foreach (var sessionId in expired)
                    _sessions.Remove(sessionId);
            }
        }

        /// <summary>
        /// Bắt đầu task nền dọn session hết hạn.
        /// </summary>
        public void Start()
        {
            if (_cleanerTask != null && !_cleanerTask.IsCompleted)
                return;

            if (_cts.IsCancellationRequested)
                _cts = new CancellationTokenSource();

            _cleanerTask = Task.Run(() => Run(_cts.Token));
        }

        /// <summary>
        /// Dừng task dọn session.
        /// </summary>
        public void Stop()
        {
            _cts.Cancel();

            try
            {
                _cleanerTask?.Wait();
            }
            catch (AggregateException ae)
            {
                ae.Handle(e => e is OperationCanceledException);
            }
        }

        /// <summary>
        /// Vòng lặp chạy nền, dọn session hết hạn định kỳ.
        /// </summary>
        private async Task Run(CancellationToken token)
        {
            while (!token.IsCancellationRequested)
            {
                try
                {
                    CleanExpiredSessions();
                    await Task.Delay(600_000, token); // dọn mỗi 600 giây
                }
                catch (OperationCanceledException)
                {
                    break;
                }
                catch (Exception ex)
                {
                    Simulation.GetModel<LogManager>()?.Log(ex); // nếu cần log lỗi
                    await Task.Delay(1000, token);
                }
            }
        }

    }

}
