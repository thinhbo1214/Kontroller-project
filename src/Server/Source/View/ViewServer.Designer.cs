using Server.Source.Core;
using Server.Source.Manager;

namespace Server.Source.View
{
    partial class ViewServer
    {
        #region View winform

        private System.ComponentModel.IContainer components = null;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(ViewServer));
            buttonStart = new Button();
            labelPort = new Label();
            labelCertificate = new Label();
            textBox1 = new TextBox();
            textBox2 = new TextBox();
            labelWWW = new Label();
            textBox3 = new TextBox();
            labelSetting = new Label();
            linkWeb = new LinkLabel();
            pictureBox1 = new PictureBox();
            labelContact = new Label();
            linkFB = new LinkLabel();
            linkEmail = new LinkLabel();
            listLog = new TextBox();
            ((System.ComponentModel.ISupportInitialize)pictureBox1).BeginInit();
            SuspendLayout();
            // 
            // buttonStart
            // 
            buttonStart.BackColor = SystemColors.ButtonFace;
            buttonStart.Cursor = Cursors.Hand;
            buttonStart.Location = new Point(127, 291);
            buttonStart.Name = "buttonStart";
            buttonStart.Size = new Size(94, 29);
            buttonStart.TabIndex = 0;
            buttonStart.Text = "Start";
            buttonStart.UseVisualStyleBackColor = false;
            buttonStart.Click += button1_Click;
            // 
            // labelPort
            // 
            labelPort.AutoSize = true;
            labelPort.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelPort.Location = new Point(55, 163);
            labelPort.Name = "labelPort";
            labelPort.Size = new Size(54, 23);
            labelPort.TabIndex = 1;
            labelPort.Text = "Port: ";
            // 
            // labelCertificate
            // 
            labelCertificate.AutoSize = true;
            labelCertificate.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelCertificate.Location = new Point(9, 208);
            labelCertificate.Name = "labelCertificate";
            labelCertificate.Size = new Size(97, 23);
            labelCertificate.TabIndex = 2;
            labelCertificate.Text = "Certificate:";
            // 
            // textBox1
            // 
            textBox1.Font = new Font("Segoe UI", 10.2F, FontStyle.Regular, GraphicsUnit.Point, 0);
            textBox1.Location = new Point(115, 156);
            textBox1.Name = "textBox1";
            textBox1.Size = new Size(179, 30);
            textBox1.TabIndex = 3;
            // 
            // textBox2
            // 
            textBox2.Font = new Font("Segoe UI", 10.2F, FontStyle.Regular, GraphicsUnit.Point, 0);
            textBox2.Location = new Point(115, 201);
            textBox2.Name = "textBox2";
            textBox2.Size = new Size(179, 30);
            textBox2.TabIndex = 4;
            textBox2.DoubleClick += textBox2_DoubleClick;
            // 
            // labelWWW
            // 
            labelWWW.AutoSize = true;
            labelWWW.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelWWW.Location = new Point(49, 251);
            labelWWW.Name = "labelWWW";
            labelWWW.Size = new Size(57, 23);
            labelWWW.TabIndex = 5;
            labelWWW.Text = "www:";
            // 
            // textBox3
            // 
            textBox3.Font = new Font("Segoe UI", 10.2F, FontStyle.Regular, GraphicsUnit.Point, 0);
            textBox3.Location = new Point(115, 244);
            textBox3.Name = "textBox3";
            textBox3.Size = new Size(179, 30);
            textBox3.TabIndex = 6;
            textBox3.DoubleClick += textBox3_DoubleClick;
            // 
            // labelSetting
            // 
            labelSetting.AutoSize = true;
            labelSetting.Font = new Font("Segoe UI", 19.8000011F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelSetting.Location = new Point(49, 77);
            labelSetting.Name = "labelSetting";
            labelSetting.Size = new Size(257, 46);
            labelSetting.TabIndex = 8;
            labelSetting.Text = "Server Settings";
            // 
            // linkWeb
            // 
            linkWeb.AutoSize = true;
            linkWeb.Location = new Point(242, 300);
            linkWeb.Name = "linkWeb";
            linkWeb.Size = new Size(77, 20);
            linkWeb.TabIndex = 9;
            linkWeb.TabStop = true;
            linkWeb.Text = "WebClient";
            linkWeb.LinkClicked += linkLabel1_LinkClicked;
            // 
            // pictureBox1
            // 
            pictureBox1.BackColor = Color.Transparent;
            pictureBox1.Image = (Image)resources.GetObject("pictureBox1.Image");
            pictureBox1.Location = new Point(9, 561);
            pictureBox1.Name = "pictureBox1";
            pictureBox1.Size = new Size(87, 82);
            pictureBox1.SizeMode = PictureBoxSizeMode.StretchImage;
            pictureBox1.TabIndex = 10;
            pictureBox1.TabStop = false;
            // 
            // labelContact
            // 
            labelContact.AutoSize = true;
            labelContact.Location = new Point(102, 561);
            labelContact.Name = "labelContact";
            labelContact.Size = new Size(85, 20);
            labelContact.TabIndex = 11;
            labelContact.Text = "Contact me";
            // 
            // linkFB
            // 
            linkFB.AutoSize = true;
            linkFB.Location = new Point(106, 587);
            linkFB.Name = "linkFB";
            linkFB.Size = new Size(211, 20);
            linkFB.TabIndex = 12;
            linkFB.TabStop = true;
            linkFB.Text = "Facebook: Nguyễn Minh Thuận";
            linkFB.LinkClicked += linkFB_LinkClicked;
            // 
            // linkEmail
            // 
            linkEmail.AutoSize = true;
            linkEmail.Location = new Point(107, 615);
            linkEmail.Name = "linkEmail";
            linkEmail.Size = new Size(185, 20);
            linkEmail.TabIndex = 13;
            linkEmail.TabStop = true;
            linkEmail.Text = "Email: Nguyễn Minh Thuận";
            linkEmail.LinkClicked += linkLabel2_LinkClicked;
            // 
            // listLog
            // 
            listLog.Location = new Point(366, 35);
            listLog.Multiline = true;
            listLog.Name = "listLog";
            listLog.ScrollBars = ScrollBars.Both;
            listLog.Size = new Size(650, 572);
            listLog.TabIndex = 14;
            // 
            // ViewServer
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = Color.AliceBlue;
            ClientSize = new Size(1028, 655);
            Controls.Add(listLog);
            Controls.Add(linkEmail);
            Controls.Add(linkFB);
            Controls.Add(labelContact);
            Controls.Add(pictureBox1);
            Controls.Add(linkWeb);
            Controls.Add(labelSetting);
            Controls.Add(textBox3);
            Controls.Add(labelWWW);
            Controls.Add(textBox2);
            Controls.Add(textBox1);
            Controls.Add(labelCertificate);
            Controls.Add(labelPort);
            Controls.Add(buttonStart);
            FormBorderStyle = FormBorderStyle.FixedSingle;
            Icon = (Icon)resources.GetObject("$this.Icon");
            MaximizeBox = false;
            Name = "ViewServer";
            SizeGripStyle = SizeGripStyle.Hide;
            Text = "Server";
            Load += ViewServer_Load;
            ((System.ComponentModel.ISupportInitialize)pictureBox1).EndInit();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Button buttonStart;
        private Label labelPort;
        private Label labelCertificate;
        private TextBox textBox1;
        private TextBox textBox2;
        private Label labelWWW;
        private TextBox textBox3;
        private Label labelSetting;
        private LinkLabel linkWeb;
        private PictureBox pictureBox1;
        private Label labelContact;
        private LinkLabel linkFB;
        private LinkLabel linkEmail;
        private TextBox listLog;
    }
}
