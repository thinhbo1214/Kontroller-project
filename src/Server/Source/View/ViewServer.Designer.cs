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
            components = new System.ComponentModel.Container();
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
            buttonStop = new Button();
            buttonClearLog = new Button();
            labelInfo = new Label();
            labelPortRunning = new Label();
            labelActive = new Label();
            labelNRequest = new Label();
            labelNUser = new Label();
            labelRTime = new Label();
            labelWeb = new Label();
            timer1 = new System.Windows.Forms.Timer(components);
            buttonXAMPP = new Button();
            labelServices = new Label();
            textBox4 = new TextBox();
            labelXampp = new Label();
            buttonAuto = new Button();
            ((System.ComponentModel.ISupportInitialize)pictureBox1).BeginInit();
            SuspendLayout();
            // 
            // buttonStart
            // 
            buttonStart.BackColor = SystemColors.ButtonFace;
            buttonStart.Cursor = Cursors.Hand;
            buttonStart.Location = new Point(100, 291);
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
            labelPort.Location = new Point(53, 133);
            labelPort.Name = "labelPort";
            labelPort.Size = new Size(54, 23);
            labelPort.TabIndex = 1;
            labelPort.Text = "Port: ";
            // 
            // labelCertificate
            // 
            labelCertificate.AutoSize = true;
            labelCertificate.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelCertificate.Location = new Point(7, 178);
            labelCertificate.Name = "labelCertificate";
            labelCertificate.Size = new Size(97, 23);
            labelCertificate.TabIndex = 2;
            labelCertificate.Text = "Certificate:";
            // 
            // textBox1
            // 
            textBox1.Font = new Font("Segoe UI", 10.2F, FontStyle.Regular, GraphicsUnit.Point, 0);
            textBox1.Location = new Point(113, 126);
            textBox1.Name = "textBox1";
            textBox1.Size = new Size(179, 30);
            textBox1.TabIndex = 3;
            // 
            // textBox2
            // 
            textBox2.Font = new Font("Segoe UI", 10.2F, FontStyle.Regular, GraphicsUnit.Point, 0);
            textBox2.Location = new Point(113, 171);
            textBox2.Name = "textBox2";
            textBox2.Size = new Size(179, 30);
            textBox2.TabIndex = 4;
            textBox2.DoubleClick += textBox2_DoubleClick;
            // 
            // labelWWW
            // 
            labelWWW.AutoSize = true;
            labelWWW.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelWWW.Location = new Point(47, 221);
            labelWWW.Name = "labelWWW";
            labelWWW.Size = new Size(57, 23);
            labelWWW.TabIndex = 5;
            labelWWW.Text = "www:";
            // 
            // textBox3
            // 
            textBox3.Font = new Font("Segoe UI", 10.2F, FontStyle.Regular, GraphicsUnit.Point, 0);
            textBox3.Location = new Point(113, 214);
            textBox3.Name = "textBox3";
            textBox3.Size = new Size(179, 30);
            textBox3.TabIndex = 6;
            textBox3.DoubleClick += textBox3_DoubleClick;
            // 
            // labelSetting
            // 
            labelSetting.AutoSize = true;
            labelSetting.Font = new Font("Segoe UI", 19.8000011F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelSetting.Location = new Point(47, 65);
            labelSetting.Name = "labelSetting";
            labelSetting.Size = new Size(257, 46);
            labelSetting.TabIndex = 8;
            labelSetting.Text = "Server Settings";
            // 
            // linkWeb
            // 
            linkWeb.AutoSize = true;
            linkWeb.Location = new Point(120, 525);
            linkWeb.Name = "linkWeb";
            linkWeb.Size = new Size(75, 20);
            linkWeb.TabIndex = 9;
            linkWeb.TabStop = true;
            linkWeb.Text = "Kontroller";
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
            // buttonStop
            // 
            buttonStop.BackColor = SystemColors.ButtonFace;
            buttonStop.Cursor = Cursors.Hand;
            buttonStop.Enabled = false;
            buttonStop.Location = new Point(200, 291);
            buttonStop.Name = "buttonStop";
            buttonStop.Size = new Size(94, 29);
            buttonStop.TabIndex = 15;
            buttonStop.Text = "Stop";
            buttonStop.UseVisualStyleBackColor = false;
            buttonStop.Click += buttonStop_Click;
            // 
            // buttonClearLog
            // 
            buttonClearLog.BackColor = SystemColors.ButtonFace;
            buttonClearLog.Cursor = Cursors.Hand;
            buttonClearLog.Location = new Point(922, 611);
            buttonClearLog.Name = "buttonClearLog";
            buttonClearLog.Size = new Size(94, 29);
            buttonClearLog.TabIndex = 16;
            buttonClearLog.Text = "Clear Logs";
            buttonClearLog.UseVisualStyleBackColor = false;
            buttonClearLog.Click += buttonClearLog_Click;
            // 
            // labelInfo
            // 
            labelInfo.AutoSize = true;
            labelInfo.Font = new Font("Segoe UI", 15F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelInfo.Location = new Point(55, 363);
            labelInfo.Name = "labelInfo";
            labelInfo.Size = new Size(234, 35);
            labelInfo.TabIndex = 17;
            labelInfo.Text = "Server Information";
            // 
            // labelPortRunning
            // 
            labelPortRunning.AutoSize = true;
            labelPortRunning.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelPortRunning.Location = new Point(27, 453);
            labelPortRunning.Name = "labelPortRunning";
            labelPortRunning.Size = new Size(155, 23);
            labelPortRunning.TabIndex = 18;
            labelPortRunning.Text = "Running Port: 443";
            // 
            // labelActive
            // 
            labelActive.AutoSize = true;
            labelActive.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelActive.Location = new Point(27, 407);
            labelActive.Name = "labelActive";
            labelActive.Size = new Size(106, 23);
            labelActive.TabIndex = 19;
            labelActive.Text = "Active: false";
            // 
            // labelNRequest
            // 
            labelNRequest.AutoSize = true;
            labelNRequest.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelNRequest.Location = new Point(27, 476);
            labelNRequest.Name = "labelNRequest";
            labelNRequest.Size = new Size(183, 23);
            labelNRequest.TabIndex = 20;
            labelNRequest.Text = "Number of Request: 0";
            // 
            // labelNUser
            // 
            labelNUser.AutoSize = true;
            labelNUser.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelNUser.Location = new Point(27, 499);
            labelNUser.Name = "labelNUser";
            labelNUser.Size = new Size(156, 23);
            labelNUser.TabIndex = 22;
            labelNUser.Text = "Number of User: 0";
            // 
            // labelRTime
            // 
            labelRTime.AutoSize = true;
            labelRTime.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelRTime.Location = new Point(27, 430);
            labelRTime.Name = "labelRTime";
            labelRTime.Size = new Size(125, 23);
            labelRTime.TabIndex = 23;
            labelRTime.Text = "Running Time:";
            // 
            // labelWeb
            // 
            labelWeb.AutoSize = true;
            labelWeb.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelWeb.Location = new Point(27, 522);
            labelWeb.Name = "labelWeb";
            labelWeb.Size = new Size(90, 23);
            labelWeb.TabIndex = 24;
            labelWeb.Text = "Link Web:";
            labelWeb.Click += labelWeb_Click;
            // 
            // timer1
            // 
            timer1.Tick += timer1_Tick;
            // 
            // buttonXAMPP
            // 
            buttonXAMPP.BackColor = SystemColors.ButtonFace;
            buttonXAMPP.Cursor = Cursors.Hand;
            buttonXAMPP.Location = new Point(100, 325);
            buttonXAMPP.Name = "buttonXAMPP";
            buttonXAMPP.Size = new Size(94, 29);
            buttonXAMPP.TabIndex = 25;
            buttonXAMPP.Text = "XAMPP";
            buttonXAMPP.UseVisualStyleBackColor = false;
            buttonXAMPP.Click += buttonXAMPP_Click;
            // 
            // labelServices
            // 
            labelServices.AutoSize = true;
            labelServices.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelServices.Location = new Point(12, 331);
            labelServices.Name = "labelServices";
            labelServices.Size = new Size(78, 23);
            labelServices.TabIndex = 26;
            labelServices.Text = "Services:";
            // 
            // textBox4
            // 
            textBox4.Font = new Font("Segoe UI", 10.2F, FontStyle.Regular, GraphicsUnit.Point, 0);
            textBox4.Location = new Point(113, 255);
            textBox4.Name = "textBox4";
            textBox4.Size = new Size(179, 30);
            textBox4.TabIndex = 28;
            textBox4.DoubleClick += textBox4_DoubleClick;
            // 
            // labelXampp
            // 
            labelXampp.AutoSize = true;
            labelXampp.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelXampp.Location = new Point(32, 262);
            labelXampp.Name = "labelXampp";
            labelXampp.Size = new Size(75, 23);
            labelXampp.TabIndex = 27;
            labelXampp.Text = "XAMPP:";
            // 
            // buttonAuto
            // 
            buttonAuto.BackColor = SystemColors.ButtonFace;
            buttonAuto.Cursor = Cursors.Hand;
            buttonAuto.Location = new Point(200, 325);
            buttonAuto.Name = "buttonAuto";
            buttonAuto.Size = new Size(94, 29);
            buttonAuto.TabIndex = 29;
            buttonAuto.Text = "Auto";
            buttonAuto.UseVisualStyleBackColor = false;
            buttonAuto.Click += buttonAuto_Click;
            // 
            // ViewServer
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = Color.AliceBlue;
            ClientSize = new Size(1028, 655);
            Controls.Add(buttonAuto);
            Controls.Add(textBox4);
            Controls.Add(labelXampp);
            Controls.Add(labelServices);
            Controls.Add(buttonXAMPP);
            Controls.Add(labelWeb);
            Controls.Add(labelRTime);
            Controls.Add(labelNUser);
            Controls.Add(labelNRequest);
            Controls.Add(labelActive);
            Controls.Add(labelPortRunning);
            Controls.Add(labelInfo);
            Controls.Add(buttonClearLog);
            Controls.Add(buttonStop);
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
        private Button buttonStop;
        private Button buttonClearLog;
        private Label labelInfo;
        private Label labelPortRunning;
        private Label labelActive;
        private Label labelNRequest;
        private Label labelNUser;
        private Label labelRTime;
        private Label labelWeb;
        private System.Windows.Forms.Timer timer1;
        private Button buttonXAMPP;
        private Label labelServices;
        private TextBox textBox4;
        private Label labelXampp;
        private Button buttonAuto;
    }
}
