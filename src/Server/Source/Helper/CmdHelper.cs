using Server.Source.Core;
using Server.Source.Manager;
using System.ComponentModel;
using System.Diagnostics;
using System.Text;

namespace Server.Source.Helper
{
    /// <summary>
    /// Hỗ trợ thực thi các lệnh CMD trong hệ thống.
    /// Cho phép chạy lệnh có hoặc không cần quyền admin, hiển thị hoặc ẩn cửa sổ CMD,
    /// và nhận kết quả đầu ra (synchronously hoặc asynchronously).
    /// </summary>
    public static class CmdHelper
    {
        /// <summary>
        /// Thực thi lệnh CMD không cần nhận kết quả đầu ra.
        /// </summary>
        /// <param name="command">Chuỗi lệnh cần thực thi.</param>
        /// <param name="runAsAdmin">Có chạy dưới quyền admin hay không.</param>
        /// <param name="showWindow">Có hiển thị cửa sổ CMD hay không.</param>
        /// <param name="workingDirectory">Thư mục làm việc hiện tại (nếu có).</param>
        public static void RunCommand(
        string command,
        bool runAsAdmin = false,
        bool showWindow = false,
        string workingDirectory = null)
        {
            var psi = new ProcessStartInfo
            {
                FileName = "cmd.exe",
                Arguments = $"/c {command}",
                UseShellExecute = true,
                Verb = runAsAdmin ? "runas" : null,
                WindowStyle = showWindow ? ProcessWindowStyle.Normal : ProcessWindowStyle.Hidden,
            };

            if (!string.IsNullOrEmpty(workingDirectory))
            {
                psi.WorkingDirectory = workingDirectory;
            }

            try
            {
                Process.Start(psi);
            }
            catch (Win32Exception ex)
            {
                Simulation.GetModel<LogManager>().Log(ex);
            }
        }

        /// <summary>
        /// Thực thi lệnh CMD và nhận kết quả đầu ra đồng bộ.
        /// </summary>
        /// <param name="command">Chuỗi lệnh cần thực thi.</param>
        /// <param name="runAsAdmin">Có chạy dưới quyền admin hay không.</param>
        /// <param name="workingDirectory">Thư mục làm việc hiện tại (nếu có).</param>
        /// <returns>Kết quả xuất ra từ lệnh đã thực thi (stdout + stderr).</returns>
        public static string RunCommandWithOutput(string command, bool runAsAdmin = false, string workingDirectory = null)
        {
            var psi = new ProcessStartInfo
            {
                FileName = "cmd.exe",
                Arguments = $"/c {command}",
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                CreateNoWindow = true,
                Verb = runAsAdmin ? "runas" : null,
            };

            if (!string.IsNullOrEmpty(workingDirectory))
            {
                psi.WorkingDirectory = workingDirectory;
            }

            try
            {
                using (var process = Process.Start(psi))
                {
                    process.WaitForExit();
                    string output = process.StandardOutput.ReadToEnd();
                    string error = process.StandardError.ReadToEnd();
                    return output + error;
                }
            }
            catch (Win32Exception ex)
            {
                return $"ERROR: {ex.Message}";
            }
        }

        /// <summary>
        /// Thực thi lệnh CMD và nhận kết quả đầu ra bất đồng bộ (async).
        /// </summary>
        /// <param name="command">Chuỗi lệnh cần thực thi.</param>
        /// <param name="runAsAdmin">Có chạy dưới quyền admin hay không.</param>
        /// <param name="workingDirectory">Thư mục làm việc hiện tại (nếu có).</param>
        /// <returns>Task chứa chuỗi đầu ra từ lệnh (stdout + stderr).</returns>
        public static async Task<string> RunCommandWithOutputAsync(string command, bool runAsAdmin = false, string workingDirectory = null)
        {
            var psi = new ProcessStartInfo
            {
                FileName = "cmd.exe",
                Arguments = $"/c {command}",
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                CreateNoWindow = true,
                Verb = runAsAdmin ? "runas" : null,
            };

            if (!string.IsNullOrEmpty(workingDirectory))
            {
                psi.WorkingDirectory = workingDirectory;
            }

            try
            {
                using (var process = new Process { StartInfo = psi })
                {
                    var outputBuilder = new StringBuilder();
                    var errorBuilder = new StringBuilder();

                    process.OutputDataReceived += (sender, args) => { if (args.Data != null) outputBuilder.AppendLine(args.Data); };
                    process.ErrorDataReceived += (sender, args) => { if (args.Data != null) errorBuilder.AppendLine(args.Data); };

                    process.Start();

                    process.BeginOutputReadLine();
                    process.BeginErrorReadLine();

                    await Task.Run(() => process.WaitForExit());

                    return outputBuilder.ToString() + errorBuilder.ToString();
                }
            }
            catch (Win32Exception ex)
            {
                return $"ERROR: {ex.Message}";
            }
        }

    }
}
