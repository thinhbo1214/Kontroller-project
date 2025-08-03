using Server.Source.Core;
using Server.Source.Helper;
using Server.Source.NetCoreServer;

namespace Server.Source.Manager
{
    public class SessionManager
    {
        private readonly ReaderWriterLockSlim _lock = new();
        private readonly Dictionary<string, SessionEntry> _sessions = new();
        public int NumberSession => _sessions.Count;
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
            public string UserId;
            public DateTime ExpireAt;

            public bool IsExpired => DateTime.UtcNow > ExpireAt;
        }

        public void Store(string sessionId, string userId, TimeSpan? ttl = null)
        {
            ttl ??= TimeSpan.FromHours(1);
            using (new WriteLock(_lock))
            {
                _sessions[sessionId] = new SessionEntry
                {
                    UserId = userId,
                    ExpireAt = DateTime.UtcNow + ttl.Value,
                };
            }
        }

        public string? GetUserId(string sessionId)
        {
            using (new ReadLock(_lock))
            {
                if (_sessions.TryGetValue(sessionId, out var entry))
                {
                    if (!entry.IsExpired)
                    {
                        return entry.UserId;
                    }
                }
            }

            RemoveSession(sessionId); // xoá nếu hết hạn hoặc IP sai
            return null;
        }

        public bool IsUser(string sessionId)
        {
            using (new ReadLock(_lock))
            {
                if (_sessions.TryGetValue(sessionId, out var entry))
                {
                    if (!entry.IsExpired)
                    {
                        return true;
                    }
                }
            }

            RemoveSession(sessionId); // xoá nếu hết hạn hoặc IP sai
            return false;
        }
        public bool Authorization(HttpRequest request, out string userId, HttpsSession session = null)
        {
            userId = "";
            string token = TokenHelper.GetToken(request);
            if (TokenHelper.TryParseToken(token, out var sessionId))
            {
                string? id = GetUserId(sessionId);
                if (id != null)
                {
                    userId = id;
                    return true;
                }
                else if(session != null)
                {
                    TokenHelper.RemoveToken(session.Response);
                }
            }    
            return false;
        }
        public bool RemoveCurrentSession(HttpRequest request, HttpsSession session = null)
        {
            string token = TokenHelper.GetToken(request);

            if (TokenHelper.TryParseToken(token, out var sessionId))
            {
                if (sessionId != null)
                {
                    RemoveSession(sessionId);
                }
                TokenHelper.RemoveToken(session.Response);
                return true;
            }
            return false;
        }
        private void RemoveSessionInternal(string sessionId)
        {
            _sessions.Remove(sessionId);
        }

        private void RemoveSession(string sessionId)
        {
            using (new WriteLock(_lock))
            {
                RemoveSessionInternal(sessionId);
            }
        }

        public void RemoveAllSessionOfUser(string userId)
        {
            using (new WriteLock(_lock))
            {
                var sessionIds = _sessions
                    .Where(kv => kv.Value.UserId == userId)
                    .Select(kv => kv.Key)
                    .ToList();

                foreach (var sessionId in sessionIds)
                {
                    RemoveSessionInternal(sessionId); // không lock lại
                }
            }
        }

        public void RemoveAllSessionsExcept(string userId, string sessionIdToKeep)
        {
            using (new WriteLock(_lock))
            {
                var sessionIds = _sessions
                    .Where(kv => kv.Value.UserId == userId && kv.Key != sessionIdToKeep)
                    .Select(kv => kv.Key)
                    .ToList();

                foreach (var sessionId in sessionIds)
                {
                    RemoveSessionInternal(sessionId);
                }
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
            Simulation.GetModel<LogManager>().Log("SessionManager stopped.", LogLevel.INFO, LogSource.SYSTEM);
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
