using ServerConsole.Source.Core;
using ServerConsole.Source.Manager;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerConsole.Source.View
{
    public class ViewServer
    {
        /// <summary>
        /// Bộ điều khiển tín hiệu hủy để dừng task một cách an toàn.
        /// </summary>
        private CancellationTokenSource _cts = new();

        /// <summary>
        /// Task xử lý nền.
        /// </summary>
        /// 
        private Task _viewTask;

        public void UpdateView(string log)
        {
            Console.WriteLine(log); // ví dụ đơn giản
        }
        /// <summary>
        /// Khởi chạy View Server trong nền (tự động).
        /// </summary>
        public void Start()
        {
            if (_viewTask != null && !_viewTask.IsCompleted)
                return; // đã chạy rồi

            if (_cts.IsCancellationRequested)
                _cts = new CancellationTokenSource(); // Reset token nếu đã huỷ trước đó

            Simulation.GetModel<LogManager>().OnLogPrinted += UpdateView;
            _viewTask = Task.Run(() => Run(_cts.Token));
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
                _viewTask?.Wait();
            }
            catch (AggregateException ae)
            {
                ae.Handle(e => e is OperationCanceledException);
            }

            Simulation.GetModel<LogManager>().Log("ViewServer stopped.");
        }

        /// <summary>
        /// Vòng lặp chính của Simalation Manager, chạy nền.
        /// </summary>
        /// <param name="token">CancellationToken để dừng an toàn</param>
        private async Task Run(CancellationToken token)
        {
            try
            {
                Simulation.GetModel<LogManager>().Log("Server View started...");

                while (!token.IsCancellationRequested)
                {
                    // Do something
                    await Task.Delay(1000, token); // giảm CPU load
                }

            }
            catch (Exception ex)
            {
                Simulation.GetModel<LogManager>().Log(ex);
            }
        }



    }
}
