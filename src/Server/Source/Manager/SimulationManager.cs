using Server.Source.Core;
using Server.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Server.Source.Manager
{
    public class SimulationManager
    {
        /// <summary>
        /// Bộ điều khiển tín hiệu hủy để dừng task một cách an toàn.
        /// </summary>
        private CancellationTokenSource _cts = new();

        /// <summary>
        /// Task xử lý nền.
        /// </summary>
        /// 
        private Task _simulationTask;

        /// <summary>
        /// Tối đa Task xử lý event.
        /// </summary>
        public readonly SemaphoreSlim Limiter = new SemaphoreSlim(20);

        /// <summary>
        /// Khởi chạy Simulation Manager trong nền (tự động).
        /// </summary>
        public void Start()
        {
            if (_simulationTask != null && !_simulationTask.IsCompleted)
                return; // đã chạy rồi

            if (_cts.IsCancellationRequested)
                _cts = new CancellationTokenSource(); // Reset token nếu đã huỷ trước đó

            _simulationTask = Task.Run(() => Run(_cts.Token));
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
        /// Dừng simulation và toàn bộ task nền.
        /// </summary>
        public void Stop()
        {
            _cts.Cancel();

            try
            {
                _simulationTask?.Wait();
            }
            catch (AggregateException ae)
            {
                ae.Handle(e => e is OperationCanceledException);
            }

            Simulation.GetModel<LogManager>().Log("SimulationManager stopped.", LogLevel.INFO, LogSource.SYSTEM);
        }

        /// <summary>
        /// Vòng lặp chính của Simalation Manager, chạy nền.
        /// </summary>
        /// <param name="token">CancellationToken để dừng an toàn</param>
        private async Task Run(CancellationToken token)
        {
            while (!token.IsCancellationRequested)
            {
                try
                {
                    Simulation.Tick();
                }
                catch (Exception ex)
                {
                    Simulation.GetModel<LogManager>().Log(ex);
                    await Task.Delay(1000, token);
                }
                await Task.Delay(10, token);
            }
        }
    }
}

