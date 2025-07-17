using Microsoft.IdentityModel.Tokens;
using Server.Source.Core;
using Server.Source.Helper;
using Server.Source.Manager;
using Server.Source.Model;
using Server.Source.Presenter;
using System.Diagnostics;
using System.Text.RegularExpressions;
using System.Windows.Forms;
using static Server.Source.Model.ModelServer;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.ListView;

namespace Server.Source.View
{
    public partial class ViewServer : Form
    {
        public event Action OnClickedStart;
        public event Action OnClickedStop;
        public void UpdateLogView(LogSource source, string log)
        {
            if (InvokeRequired)
            {
                // Đảm bảo gọi trên luồng UI không gây lỗi cross-thread
                BeginInvoke(new Action(() => UpdateLogView(source, log)));
                return;
            }
            if (source == LogSource.USER)
            {
                listLogUser.AppendText(log + Environment.NewLine);
            }
            else
            {
                listLogSystem.AppendText(log + Environment.NewLine);
            }

        }
        public void UpdateStatus(ServerStatus status)
        {
            if (InvokeRequired)
            {
                // Đảm bảo gọi trên luồng UI không gây lỗi cross-thread
                BeginInvoke(new Action(() => UpdateStatus(status)));
                return;
            }
            labelRTime.Text = "Running Time: " + status.ElapsedTime.ToString();
            labelNRequest.Text = "Number of Request: " + status.NumberRequest.ToString();
            labelNUser.Text = "Number of User: " + status.NumberUser.ToString();

        }

        public ViewServer()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            labelActive.Text = "Active: true";
            labelAppPort.Text = Simulation.GetModel<ModelServer>().Port.ToString();
            Simulation.GetModel<ModelServer>().ElapsedTime = TimeSpan.Zero;
            buttonStart.Enabled = false;
            OnClickedStart?.Invoke();
            buttonStop.Enabled = true;
            timer1.Start();
        }
        private void buttonStop_Click(object sender, EventArgs e)
        {
            labelActive.Text = "Active: false";
            OnClickedStop?.Invoke();
            buttonStop.Enabled = false;
            buttonStart.Enabled = true;
            timer1.Stop();
        }

        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            int Port = Simulation.GetModel<ModelServer>().Port;
            string url = $"https://localhost:{Port}";
            try
            {
                Process.Start(new ProcessStartInfo
                {
                    FileName = url,
                    UseShellExecute = true // Bắt buộc phải có trong .NET Core/.NET 5+ để mở trình duyệt
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show("Không thể mở link: " + ex.Message);
            }
        }

        private void ViewServer_Load(object sender, EventArgs e)
        {

        }

        private void linkLabel2_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            // Soạn email với subject và body sẵn
            string email = "mailto:kingnemacc@gmail.com"
                         + "?subject=Góp ý về phần mềm"
                         + "&body=Chào bạn,%0A%0ATôi muốn góp ý như sau:%0A";

            try
            {
                Process.Start(new ProcessStartInfo
                {
                    FileName = email,
                    UseShellExecute = true // Bắt buộc trong WinForms .NET Core/.NET 5+
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show("Không thể mở ứng dụng email: " + ex.Message);
            }
        }

        private void linkFB_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            string url = "https://www.facebook.com/minhthuan.nguyen.773124";
            try
            {
                Process.Start(new ProcessStartInfo
                {
                    FileName = url,
                    UseShellExecute = true // Bắt buộc phải có trong .NET Core/.NET 5+ để mở trình duyệt
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show("Không thể mở link: " + ex.Message);
            }
        }

        private void buttonClearLog_Click(object sender, EventArgs e)
        {
            listLogUser.Clear();
            MessageBox.Show("Đã xoá logs!!!");
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            Simulation.GetModel<ModelServer>().ElapsedTime += TimeSpan.FromMilliseconds(100);

        }


        private void buttonSQLStop_Click(object sender, EventArgs e)
        {
            Simulation.GetModel<DatabaseManager>().StopSqlService();
            buttonSQLStop.Enabled = false;
            buttonSQLStart.Enabled = true;
        }

        private void buttonSQLStart_Click(object sender, EventArgs e)
        {
            Simulation.GetModel<DatabaseManager>().StartSqlService();
            buttonSQLStart.Enabled = false;
            buttonSQLStop.Enabled = true;
        }

        private void linkGithub_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            string url = "https://github.com/thinhbo1214/Kontroller-project";
            try
            {
                Process.Start(new ProcessStartInfo
                {
                    FileName = url,
                    UseShellExecute = true // Bắt buộc phải có trong .NET Core/.NET 5+ để mở trình duyệt
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show("Không thể mở link: " + ex.Message);
            }
        }

        private void buttonNetstat_Click(object sender, EventArgs e)
        {
            string output = CmdHelper.RunCommandWithOutput("netstat -ano");
            var lines = output.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries);

            // Xóa cũ
            tableNetstat.Controls.Clear();
            tableNetstat.RowStyles.Clear();
            tableNetstat.RowCount = 1;

            // Header
            string[] headers = { "Proto", "Local Address", "Foreign Address", "State", "PID" };
            for (int i = 0; i < headers.Length; i++)
            {
                var label = new Label() { Text = headers[i], AutoSize = true, Font = new Font("Segoe UI", 9, FontStyle.Bold) };
                tableNetstat.Controls.Add(label, i, 0);
            }

            // Dữ liệu
            int row = 1;
            foreach (string line in lines)
            {
                if (line.StartsWith("  ") || line.StartsWith("Proto")) continue; // Bỏ dòng tiêu đề của netstat
                var parts = Regex.Split(line.Trim(), @"\s+"); // tách theo nhiều khoảng trắng

                if (parts.Length >= 5)
                {
                    tableNetstat.RowCount++;
                    for (int i = 0; i < 5; i++)
                    {
                        var label = new Label() { Text = parts[i], AutoSize = true, Font = new Font("Consolas", 9) };
                        tableNetstat.Controls.Add(label, i, row);
                    }
                    row++;
                }
            }
        }

        private void buttonCmd_Click(object sender, EventArgs e)
        {
            string path = Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
            CmdHelper.RunCommand("start cmd", showWindow: true, workingDirectory: path);
        }

        private void buttonExplorer_Click(object sender, EventArgs e)
        {
            string path = Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
            CmdHelper.RunCommand("explorer .", showWindow: true, workingDirectory: path);
        }
    }
}
