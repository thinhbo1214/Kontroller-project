using Microsoft.IdentityModel.Tokens;
using Server.Source.Core;
using Server.Source.Helper;
using Server.Source.Manager;
using Server.Source.Model;
using Server.Source.Presenter;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;
using static Server.Source.Model.ModelServer;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.ListView;

namespace Server.Source.View
{
    /// <summary>
    /// Giao diện người dùng chính của ứng dụng máy chủ, hiển thị trạng thái và log, đồng thời cung cấp các nút điều khiển.
    /// </summary>
    public partial class ViewServer : Form
    {
        /// <summary>
        /// Sự kiện được kích hoạt khi nút khởi động được nhấn.
        /// </summary>
        public event Action OnClickedStart;

        /// <summary>
        /// Sự kiện được kích hoạt khi nút dừng được nhấn.
        /// </summary>
        public event Action OnClickedStop;

        /// <summary>
        /// Cập nhật giao diện hiển thị log dựa trên nguồn log.
        /// </summary>
        /// <param name="source">Nguồn log (<see cref="LogSource.USER"/> hoặc <see cref="LogSource.SYSTEM"/>).</param>
        /// <param name="log">Nội dung log cần hiển thị.</param>
        public void UpdateLogView(LogSource source, string log)
        {
            if (InvokeRequired)
            {
                // Đảm bảo gọi trên luồng UI để tránh lỗi cross-thread
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

        /// <summary>
        /// Cập nhật giao diện hiển thị trạng thái máy chủ.
        /// </summary>
        /// <param name="status">Trạng thái máy chủ (<see cref="ServerStatus"/>).</param>
        public void UpdateStatus(ServerStatus status)
        {
            if (InvokeRequired)
            {
                // Đảm bảo gọi trên luồng UI để tránh lỗi cross-thread
                BeginInvoke(new Action(() => UpdateStatus(status)));
                return;
            }
            labelRTime.Text = "Running Time: " + status.ElapsedTime.ToString();
            labelNRequest.Text = "Number of Request: " + status.NumberRequest.ToString();
            labelNUser.Text = "Number of User: " + status.NumberUser.ToString();
            labelCpuUsage.Text = "CPU Usage: " + status.CpuUsage.ToString("0.0") + " %";
            labelMemoryUsage.Text = "Memory Usage: " + status.MemoryUsage;
        }

        /// <summary>
        /// Khởi tạo giao diện <see cref="ViewServer"/>.
        /// </summary>
        public ViewServer()
        {
            InitializeComponent();
        }

        /// <summary>
        /// Xử lý sự kiện nhấn nút khởi động ứng dụng.
        /// </summary>
        /// <param name="sender">Đối tượng gửi sự kiện.</param>
        /// <param name="e">Thông tin sự kiện.</param>
        private void button1_Click(object sender, EventArgs e)
        {
            labelAppPort.Text = Simulation.GetModel<ModelServer>().Port.ToString();
            Simulation.GetModel<ModelServer>().ElapsedTime = TimeSpan.Zero;
            buttonStartApp.Enabled = false;
            OnClickedStart?.Invoke();
            buttonStopApp.Enabled = true;
            timer1.Start();
        }

        /// <summary>
        /// Xử lý sự kiện nhấn nút dừng ứng dụng.
        /// </summary>
        /// <param name="sender">Đối tượng gửi sự kiện.</param>
        /// <param name="e">Thông tin sự kiện.</param>
        private void buttonStop_Click(object sender, EventArgs e)
        {
            OnClickedStop?.Invoke();
            buttonStopApp.Enabled = false;
            buttonStartApp.Enabled = true;
            timer1.Stop();
        }

        /// <summary>
        /// Xử lý sự kiện nhấn liên kết để mở trang web của máy chủ trong trình duyệt.
        /// </summary>
        /// <param name="sender">Đối tượng gửi sự kiện.</param>
        /// <param name="e">Thông tin sự kiện liên kết.</param>
        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            int Port = Simulation.GetModel<ModelServer>().Port;
            string url = $"https://localhost:{Port}";
            try
            {
                Process.Start(new ProcessStartInfo
                {
                    FileName = url,
                    UseShellExecute = true // Bắt buộc trong .NET Core/.NET 5+ để mở trình duyệt
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show("Không thể mở link: " + ex.Message);
            }
        }

        /// <summary>
        /// Xử lý sự kiện tải giao diện <see cref="ViewServer"/>.
        /// </summary>
        /// <param name="sender">Đối tượng gửi sự kiện.</param>
        /// <param name="e">Thông tin sự kiện.</param>
        private void ViewServer_Load(object sender, EventArgs e)
        {
        }

        /// <summary>
        /// Xử lý sự kiện nhấn liên kết để gửi email góp ý.
        /// </summary>
        /// <param name="sender">Đối tượng gửi sự kiện.</param>
        /// <param name="e">Thông tin sự kiện liên kết.</param>
        private void linkLabel2_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            string email = "mailto:kingnemacc@gmail.com"
                         + "?subject=Góp ý về phần mềm"
                         + "&body=Chào bạn,%0A%0ATôi muốn góp ý như sau:%0A";
            try
            {
                Process.Start(new ProcessStartInfo
                {
                    FileName = email,
                    UseShellExecute = true // Bắt buộc trong .NET Core/.NET 5+ để mở ứng dụng email
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show("Không thể mở ứng dụng email: " + ex.Message);
            }
        }

        /// <summary>
        /// Xử lý sự kiện nhấn liên kết để mở trang Facebook.
        /// </summary>
        /// <param name="sender">Đối tượng gửi sự kiện.</param>
        /// <param name="e">Thông tin sự kiện liên kết.</param>
        private void linkFB_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            string url = "https://www.facebook.com/minhthuan.nguyen.773124";
            try
            {
                Process.Start(new ProcessStartInfo
                {
                    FileName = url,
                    UseShellExecute = true // Bắt buộc trong .NET Core/.NET 5+ để mở trình duyệt
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show("Không thể mở link: " + ex.Message);
            }
        }

        /// <summary>
        /// Xử lý sự kiện nhấn nút xóa log người dùng.
        /// </summary>
        /// <param name="sender">Đối tượng gửi sự kiện.</param>
        /// <param name="e">Thông tin sự kiện.</param>
        private void buttonClearLog_Click(object sender, EventArgs e)
        {
            listLogUser.Clear();
            MessageBox.Show("Đã xoá logs!!!");
        }

        /// <summary>
        /// Xử lý sự kiện nhấn nút dừng dịch vụ SQL Server.
        /// </summary>
        /// <param name="sender">Đối tượng gửi sự kiện.</param>
        /// <param name="e">Thông tin sự kiện.</param>
        private void buttonSQLStop_Click(object sender, EventArgs e)
        {
            Simulation.GetModel<DatabaseManager>().StopSqlService();
            buttonStopSQL.Enabled = false;
            buttonStartSQL.Enabled = true;
        }

        /// <summary>
        /// Xử lý sự kiện nhấn nút khởi động dịch vụ SQL Server.
        /// </summary>
        /// <param name="sender">Đối tượng gửi sự kiện.</param>
        /// <param name="e">Thông tin sự kiện.</param>
        private void buttonSQLStart_Click(object sender, EventArgs e)
        {
            Simulation.GetModel<DatabaseManager>().StartSqlService();
            buttonStartSQL.Enabled = false;
            buttonStopSQL.Enabled = true;
        }

        /// <summary>
        /// Xử lý sự kiện nhấn liên kết để mở trang GitHub của dự án.
        /// </summary>
        /// <param name="sender">Đối tượng gửi sự kiện.</param>
        /// <param name="e">Thông tin sự kiện liên kết.</param>
        private void linkGithub_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            string url = "https://github.com/thinhbo1214/Kontroller-project";
            try
            {
                Process.Start(new ProcessStartInfo
                {
                    FileName = url,
                    UseShellExecute = true // Bắt buộc trong .NET Core/.NET 5+ để mở trình duyệt
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show("Không thể mở link: " + ex.Message);
            }
        }

        /// <summary>
        /// Xử lý sự kiện nhấn nút mở form Netstat.
        /// </summary>
        /// <param name="sender">Đối tượng gửi sự kiện.</param>
        /// <param name="e">Thông tin sự kiện.</param>
        private void buttonNetstat_Click(object sender, EventArgs e)
        {
            var netstatForm = new NetstatForm();
            netstatForm.Show();
        }

        /// <summary>
        /// Xử lý sự kiện nhấn nút mở Command Prompt tại thư mục thực thi.
        /// </summary>
        /// <param name="sender">Đối tượng gửi sự kiện.</param>
        /// <param name="e">Thông tin sự kiện.</param>
        private void buttonCmd_Click(object sender, EventArgs e)
        {
            string path = Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
            CmdHelper.RunCommand("start cmd", workingDirectory: path);
        }

        /// <summary>
        /// Xử lý sự kiện nhấn nút mở File Explorer tại thư mục thực thi.
        /// </summary>
        /// <param name="sender">Đối tượng gửi sự kiện.</param>
        /// <param name="e">Thông tin sự kiện.</param>
        private void buttonExplorer_Click(object sender, EventArgs e)
        {
            string path = Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
            CmdHelper.RunCommand("explorer .", workingDirectory: path);
        }

        /// <summary>
        /// Xử lý sự kiện nhấn nút xóa log hệ thống.
        /// </summary>
        /// <param name="sender">Đối tượng gửi sự kiện.</param>
        /// <param name="e">Thông tin sự kiện.</param>
        private void buttonClearLogsS_Click(object sender, EventArgs e)
        {
            listLogSystem.Clear();
            MessageBox.Show("Đã xoá logs!!!");
        }

        /// <summary>
        /// Xử lý sự kiện nhấn hình ảnh để mở trang web của trường HCMUS.
        /// </summary>
        /// <param name="sender">Đối tượng gửi sự kiện.</param>
        /// <param name="e">Thông tin sự kiện.</param>
        private void pictureBox1_Click(object sender, EventArgs e)
        {
            string url = "https://hcmus.edu.vn/";
            try
            {
                Process.Start(new ProcessStartInfo
                {
                    FileName = url,
                    UseShellExecute = true // Bắt buộc trong .NET Core/.NET 5+ để mở trình duyệt
                });
            }
            catch (Exception ex)
            {
                MessageBox.Show("Không thể mở link: " + ex.Message);
            }
        }

        /// <summary>
        /// Xử lý sự kiện nhấn nút mở cửa sổ quản lý dịch vụ Windows.
        /// </summary>
        /// <param name="sender">Đối tượng gửi sự kiện.</param>
        /// <param name="e">Thông tin sự kiện.</param>
        private void buttonServices_Click(object sender, EventArgs e)
        {
            CmdHelper.RunCommand("services.msc");
        }

        /// <summary>
        /// Xử lý sự kiện nhấn nút mở form cấu hình.
        /// </summary>
        /// <param name="sender">Đối tượng gửi sự kiện.</param>
        /// <param name="e">Thông tin sự kiện.</param>
        private void buttonConfig_Click(object sender, EventArgs e)
        {
            var configForm = new ConfigForm();
            configForm.ShowDialog();
        }

        /// <summary>
        /// Xử lý sự kiện nhấn nút trợ giúp (chưa triển khai).
        /// </summary>
        /// <param name="sender">Đối tượng gửi sự kiện.</param>
        /// <param name="e">Thông tin sự kiện.</param>
        private void buttonHelp_Click(object sender, EventArgs e)
        {
        }

        /// <summary>
        /// Xử lý sự kiện nhấn nút mở thư mục log hệ thống trong File Explorer.
        /// </summary>
        /// <param name="sender">Đối tượng gửi sự kiện.</param>
        /// <param name="e">Thông tin sự kiện.</param>
        private void buttonOpenLogsS_Click(object sender, EventArgs e)
        {
            var logDir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "logs");
            var log_system = Path.Combine(logDir, "log_system");
            CmdHelper.RunCommand("explorer .", workingDirectory: log_system);
        }

        /// <summary>
        /// Xử lý sự kiện nhấn nút mở thư mục log người dùng trong File Explorer.
        /// </summary>
        /// <param name="sender">Đối tượng gửi sự kiện.</param>
        /// <param name="e">Thông tin sự kiện.</param>
        private void buttonOpenLogsU_Click(object sender, EventArgs e)
        {
            var logDir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "logs");
            var log_user = Path.Combine(logDir, "log_user");
            CmdHelper.RunCommand("explorer .", workingDirectory: log_user);
        }
    }
}