using Microsoft.IdentityModel.Tokens;
using Server.Source.Core;
using Server.Source.Manager;
using Server.Source.Model;
using Server.Source.Presenter;
using System.Diagnostics;
using System.Windows.Forms;
using static Server.Source.Model.ModelServer;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.ListView;

namespace Server.Source.View
{
    public partial class ViewServer : Form
    {
        public event Action<int, string, string, string> OnClickedStart;
        public event Action OnClickedStop;
        public void UpdateLogView(string log)
        {
            if (InvokeRequired)
            {
                // Đảm bảo gọi trên luồng UI không gây lỗi cross-thread
                BeginInvoke(new Action(() => UpdateLogView(log)));
                return;
            }
            listLog.AppendText(log + Environment.NewLine);
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
            labelPortRunning.Text = "Running Port: " + status.Port.ToString();
            labelNRequest.Text = "Number of Request: " + status.NumberRequest.ToString();
            labelNUser.Text = "Number of User: " + status.NumberUser.ToString();

        }

        public ViewServer()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (!textBox1.Text.IsNullOrEmpty() && !textBox2.Text.IsNullOrEmpty() && !textBox3.Text.IsNullOrEmpty() && !textBox4.Text.IsNullOrEmpty())
            {
                labelActive.Text = "Active: true";
                Simulation.GetModel<ModelServer>().ElapsedTime = TimeSpan.Zero;
                buttonStart.Enabled = false;
                OnClickedStart?.Invoke(int.Parse(textBox1.Text), textBox2.Text, textBox3.Text, textBox4.Text);
                buttonStop.Enabled = true;
                timer1.Start();
            }
            else
            {
                MessageBox.Show("Không để trống");
            }
        }
        private void buttonStop_Click(object sender, EventArgs e)
        {
            labelActive.Text = "Active: false";
            OnClickedStop?.Invoke();
            buttonStop.Enabled = false;
            buttonStart.Enabled = true;
            timer1.Stop();
        }
        private void textBox2_DoubleClick(object sender, EventArgs e)
        {
            using (OpenFileDialog openFileDialog = new OpenFileDialog())
            {
                openFileDialog.Title = "Chọn file chứng chỉ:";
                openFileDialog.Filter = "Tất cả các file (*.*)|*.*"; // hoặc lọc theo đuôi ví dụ .cer, .crt, .pem

                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    string filePath = openFileDialog.FileName;
                    textBox2.Text = filePath; // ghi vào textbox luôn
                }
            }
        }

        private void textBox3_DoubleClick(object sender, EventArgs e)
        {
            using (FolderBrowserDialog folderDialog = new FolderBrowserDialog())
            {
                folderDialog.Description = "Chọn folder chứa file tĩnh web:";
                if (folderDialog.ShowDialog() == DialogResult.OK)
                {
                    string folderPath = folderDialog.SelectedPath;
                    textBox3.Text = folderPath;
                }
            }
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
            listLog.Clear();
            MessageBox.Show("Đã xoá logs!!!");
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            Simulation.GetModel<ModelServer>().ElapsedTime += TimeSpan.FromMilliseconds(100);

        }

        private void labelWeb_Click(object sender, EventArgs e)
        {

        }

        private void buttonXAMPP_Click(object sender, EventArgs e)
        {
            try
            {
                string xamppDir = Simulation.GetModel<ModelServer>().XAMPP;

                // Đường dẫn đến file batch trong thư mục extra_files
                string batchFile = Path.Combine(xamppDir, "Run_xampp.bat");

                if (!File.Exists(batchFile))
                {
                    MessageBox.Show("File batch không tồn tại: " + batchFile);
                    return;
                }


                Process.Start(new ProcessStartInfo
                {
                    FileName = "cmd.exe",
                    Arguments = $"/c \"{batchFile}\"",
                    UseShellExecute = true,
                    //WorkingDirectory = Path.GetDirectoryName(batchFile),
                    // Không dùng Verb "runas" để không yêu cầu admin

                });
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi khi chạy file batch: " + ex.Message + "\n" + ex.StackTrace);
            }
        }

        private void textBox4_DoubleClick(object sender, EventArgs e)
        {
            using (FolderBrowserDialog folderDialog = new FolderBrowserDialog())
            {
                folderDialog.Description = "Chọn folder chứa xampp:";
                if (folderDialog.ShowDialog() == DialogResult.OK)
                {
                    string folderPath = folderDialog.SelectedPath;
                    textBox4.Text = folderPath;
                }
            }
        }

        private void buttonAuto_Click(object sender, EventArgs e)
        {
            var model = Simulation.GetModel<ModelServer>();
            if (textBox1.Text.IsNullOrEmpty()) textBox1.Text = model.Port.ToString();
            if (textBox2.Text.IsNullOrEmpty()) textBox2.Text = model.Certificate;
            if (textBox3.Text.IsNullOrEmpty()) textBox3.Text = model.WWW;
            if (textBox4.Text.IsNullOrEmpty()) textBox4.Text = model.XAMPP;

            MessageBox.Show("✅ Đã tự động điền cấu hình mặc định!");
        }
    }
}
