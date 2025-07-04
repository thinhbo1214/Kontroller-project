﻿using Server.Source.Core;
using Server.Source.Manager;
using Server.Source.Presenter;
using System.Diagnostics;

namespace Server.Source.View
{
    public partial class ViewServer : Form
    {
        public event Action<int, string, string> OnClickedStart;
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

        public ViewServer()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            OnClickedStart?.Invoke(int.Parse(textBox1.Text), textBox3.Text, textBox2.Text);
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
            string url = "https://127.0.0.1/";
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
    }
}
