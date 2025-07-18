using Server.Source.Core;
using Server.Source.Helper;
using Server.Source.Manager;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Server.Source.View
{
    public partial class NetstatForm : Form
    {
        private int currentPage = 0;
        private int rowsPerPage = 200;
        private List<string> allLines = new List<string>();

        public NetstatForm()
        {
            InitializeComponent();
            LoadNetstat();
        }

        private async void LoadNetstat()
        {
            try
            {
                // Chạy lệnh netstat
                string output = await CmdHelper.RunCommandWithOutputAsync("chcp 437 && netstat -ano", runAsAdmin: true);

                if (string.IsNullOrEmpty(output) || output.StartsWith("ERROR"))
                {
                    MessageBox.Show("Failed to retrieve netstat data: " + output);
                    return;
                }

                allLines = output.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries).ToList();

                await DisplayPage(currentPage);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error loading netstat data: " + ex.Message);
                Simulation.GetModel<LogManager>().Log(ex);
            }
        }

        private async Task DisplayPage(int page)
        {
            dataGridViewNetstat.Rows.Clear();

            int startIndex = page * rowsPerPage;
            int rowCount = 0;

            for (int i = startIndex; i < allLines.Count && rowCount < rowsPerPage; i++)
            {
                var line = allLines[i];
                if (string.IsNullOrWhiteSpace(line) || line.Trim().StartsWith("Proto", StringComparison.OrdinalIgnoreCase))
                    continue;

                var parts = Regex.Matches(line.Trim(), @"(\S+)\s+([\d\.\:]+)\s+([\d\.\:]+)\s+(\S+)\s+(\d+)");
                if (parts.Count > 0 && parts[0].Groups.Count == 6)
                {
                    dataGridViewNetstat.Rows.Add(
                        parts[0].Groups[1].Value, // Proto
                        parts[0].Groups[2].Value, // Local Address
                        parts[0].Groups[3].Value, // Foreign Address
                        parts[0].Groups[4].Value, // State
                        parts[0].Groups[5].Value  // PID
                    );
                    rowCount++;
                    Simulation.GetModel<LogManager>().Log($"Added row: {string.Join(", ", parts[0].Groups.Cast<Group>().Skip(1).Select(g => g.Value))}");
                }
            }

            if (dataGridViewNetstat.Rows.Count == 0)
            {
                MessageBox.Show($"No valid netstat data found on page {page + 1}.");
            }
        }
    }
}