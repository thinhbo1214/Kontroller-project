using Server.Source.Core;
using Server.Source.Manager;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Server.Source.Helper
{
    public static class CmdHelper
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="command"></param>
        /// <param name="runAsAdmin"></param>
        /// <param name="showWindow"></param>
        /// <param name="workingDirectory"></param>
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
