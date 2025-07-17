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
            linkWeb = new LinkLabel();
            pictureBox1 = new PictureBox();
            labelContact = new Label();
            linkFB = new LinkLabel();
            linkEmail = new LinkLabel();
            listLogUser = new TextBox();
            buttonStop = new Button();
            buttonClearLog = new Button();
            labelActive = new Label();
            labelNRequest = new Label();
            labelNUser = new Label();
            labelRTime = new Label();
            timer1 = new System.Windows.Forms.Timer(components);
            labelModule = new Label();
            buttonSQLStart = new Button();
            labelSQL = new Label();
            buttonSQLStop = new Button();
            button2 = new Button();
            labelAI = new Label();
            button3 = new Button();
            labelActions = new Label();
            labelServer = new Label();
            labelAppPort = new Label();
            labelSQLPort = new Label();
            labelAIPort = new Label();
            groupBox1 = new GroupBox();
            groupBox2 = new GroupBox();
            listLogSystem = new TextBox();
            linkGithub = new LinkLabel();
            ((System.ComponentModel.ISupportInitialize)pictureBox1).BeginInit();
            groupBox1.SuspendLayout();
            groupBox2.SuspendLayout();
            SuspendLayout();
            // 
            // buttonStart
            // 
            buttonStart.BackColor = SystemColors.ButtonFace;
            buttonStart.Cursor = Cursors.Hand;
            buttonStart.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic);
            buttonStart.Location = new Point(291, 78);
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
            labelPort.Location = new Point(161, 46);
            labelPort.Name = "labelPort";
            labelPort.Size = new Size(44, 23);
            labelPort.TabIndex = 1;
            labelPort.Text = "Port";
            // 
            // linkWeb
            // 
            linkWeb.AutoSize = true;
            linkWeb.Location = new Point(205, 479);
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
            pictureBox1.Location = new Point(13, 479);
            pictureBox1.Name = "pictureBox1";
            pictureBox1.Size = new Size(87, 82);
            pictureBox1.SizeMode = PictureBoxSizeMode.StretchImage;
            pictureBox1.TabIndex = 10;
            pictureBox1.TabStop = false;
            // 
            // labelContact
            // 
            labelContact.AutoSize = true;
            labelContact.Location = new Point(114, 479);
            labelContact.Name = "labelContact";
            labelContact.Size = new Size(85, 20);
            labelContact.TabIndex = 11;
            labelContact.Text = "Contact me";
            // 
            // linkFB
            // 
            linkFB.AutoSize = true;
            linkFB.Location = new Point(118, 505);
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
            linkEmail.Location = new Point(119, 533);
            linkEmail.Name = "linkEmail";
            linkEmail.Size = new Size(185, 20);
            linkEmail.TabIndex = 13;
            linkEmail.TabStop = true;
            linkEmail.Text = "Email: Nguyễn Minh Thuận";
            linkEmail.LinkClicked += linkLabel2_LinkClicked;
            // 
            // listLogUser
            // 
            listLogUser.Location = new Point(359, 256);
            listLogUser.Multiline = true;
            listLogUser.Name = "listLogUser";
            listLogUser.ScrollBars = ScrollBars.Both;
            listLogUser.Size = new Size(694, 269);
            listLogUser.TabIndex = 14;
            // 
            // buttonStop
            // 
            buttonStop.BackColor = SystemColors.ButtonFace;
            buttonStop.Cursor = Cursors.Hand;
            buttonStop.Enabled = false;
            buttonStop.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic);
            buttonStop.Location = new Point(391, 80);
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
            buttonClearLog.Location = new Point(959, 531);
            buttonClearLog.Name = "buttonClearLog";
            buttonClearLog.Size = new Size(94, 29);
            buttonClearLog.TabIndex = 16;
            buttonClearLog.Text = "Clear Logs";
            buttonClearLog.UseVisualStyleBackColor = false;
            buttonClearLog.Click += buttonClearLog_Click;
            // 
            // labelActive
            // 
            labelActive.AutoSize = true;
            labelActive.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelActive.Location = new Point(14, 48);
            labelActive.Name = "labelActive";
            labelActive.Size = new Size(106, 23);
            labelActive.TabIndex = 19;
            labelActive.Text = "Active: false";
            // 
            // labelNRequest
            // 
            labelNRequest.AutoSize = true;
            labelNRequest.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelNRequest.Location = new Point(13, 119);
            labelNRequest.Name = "labelNRequest";
            labelNRequest.Size = new Size(183, 23);
            labelNRequest.TabIndex = 20;
            labelNRequest.Text = "Number of Request: 0";
            // 
            // labelNUser
            // 
            labelNUser.AutoSize = true;
            labelNUser.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelNUser.Location = new Point(13, 156);
            labelNUser.Name = "labelNUser";
            labelNUser.Size = new Size(156, 23);
            labelNUser.TabIndex = 22;
            labelNUser.Text = "Number of User: 0";
            // 
            // labelRTime
            // 
            labelRTime.AutoSize = true;
            labelRTime.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelRTime.Location = new Point(13, 82);
            labelRTime.Name = "labelRTime";
            labelRTime.Size = new Size(125, 23);
            labelRTime.TabIndex = 23;
            labelRTime.Text = "Running Time:";
            // 
            // timer1
            // 
            timer1.Tick += timer1_Tick;
            // 
            // labelModule
            // 
            labelModule.AutoSize = true;
            labelModule.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelModule.Location = new Point(14, 46);
            labelModule.Name = "labelModule";
            labelModule.Size = new Size(69, 23);
            labelModule.TabIndex = 26;
            labelModule.Text = "Module";
            // 
            // buttonSQLStart
            // 
            buttonSQLStart.BackColor = SystemColors.ButtonFace;
            buttonSQLStart.Cursor = Cursors.Hand;
            buttonSQLStart.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic);
            buttonSQLStart.Location = new Point(291, 117);
            buttonSQLStart.Name = "buttonSQLStart";
            buttonSQLStart.Size = new Size(94, 29);
            buttonSQLStart.TabIndex = 30;
            buttonSQLStart.Text = "Start";
            buttonSQLStart.UseVisualStyleBackColor = false;
            buttonSQLStart.Click += buttonSQLStart_Click;
            // 
            // labelSQL
            // 
            labelSQL.AutoSize = true;
            labelSQL.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelSQL.Location = new Point(6, 117);
            labelSQL.Name = "labelSQL";
            labelSQL.Size = new Size(91, 23);
            labelSQL.TabIndex = 31;
            labelSQL.Text = "SQLServer";
            // 
            // buttonSQLStop
            // 
            buttonSQLStop.BackColor = SystemColors.ButtonFace;
            buttonSQLStop.Cursor = Cursors.Hand;
            buttonSQLStop.Enabled = false;
            buttonSQLStop.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic);
            buttonSQLStop.Location = new Point(391, 115);
            buttonSQLStop.Name = "buttonSQLStop";
            buttonSQLStop.Size = new Size(94, 29);
            buttonSQLStop.TabIndex = 32;
            buttonSQLStop.Text = "Stop";
            buttonSQLStop.UseVisualStyleBackColor = false;
            buttonSQLStop.Click += buttonSQLStop_Click;
            // 
            // button2
            // 
            button2.BackColor = SystemColors.ButtonFace;
            button2.Cursor = Cursors.Hand;
            button2.Enabled = false;
            button2.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic);
            button2.Location = new Point(391, 150);
            button2.Name = "button2";
            button2.Size = new Size(94, 29);
            button2.TabIndex = 35;
            button2.Text = "Stop";
            button2.UseVisualStyleBackColor = false;
            // 
            // labelAI
            // 
            labelAI.AutoSize = true;
            labelAI.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelAI.Location = new Point(15, 152);
            labelAI.Name = "labelAI";
            labelAI.Size = new Size(77, 23);
            labelAI.TabIndex = 34;
            labelAI.Text = "AIServer";
            // 
            // button3
            // 
            button3.BackColor = SystemColors.ButtonFace;
            button3.Cursor = Cursors.Hand;
            button3.Enabled = false;
            button3.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic);
            button3.Location = new Point(291, 152);
            button3.Name = "button3";
            button3.Size = new Size(94, 29);
            button3.TabIndex = 33;
            button3.Text = "Start";
            button3.UseVisualStyleBackColor = false;
            // 
            // labelActions
            // 
            labelActions.AutoSize = true;
            labelActions.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelActions.Location = new Point(299, 44);
            labelActions.Name = "labelActions";
            labelActions.Size = new Size(68, 23);
            labelActions.TabIndex = 36;
            labelActions.Text = "Actions";
            // 
            // labelServer
            // 
            labelServer.AutoSize = true;
            labelServer.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelServer.Location = new Point(6, 80);
            labelServer.Name = "labelServer";
            labelServer.Size = new Size(92, 23);
            labelServer.TabIndex = 37;
            labelServer.Text = "AppServer";
            // 
            // labelAppPort
            // 
            labelAppPort.AutoSize = true;
            labelAppPort.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelAppPort.Location = new Point(162, 80);
            labelAppPort.Name = "labelAppPort";
            labelAppPort.Size = new Size(44, 23);
            labelAppPort.TabIndex = 38;
            labelAppPort.Text = "Port";
            // 
            // labelSQLPort
            // 
            labelSQLPort.AutoSize = true;
            labelSQLPort.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelSQLPort.Location = new Point(162, 119);
            labelSQLPort.Name = "labelSQLPort";
            labelSQLPort.Size = new Size(50, 23);
            labelSQLPort.TabIndex = 39;
            labelSQLPort.Text = "1433";
            // 
            // labelAIPort
            // 
            labelAIPort.AutoSize = true;
            labelAIPort.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelAIPort.Location = new Point(162, 156);
            labelAIPort.Name = "labelAIPort";
            labelAIPort.Size = new Size(50, 23);
            labelAIPort.TabIndex = 40;
            labelAIPort.Text = "2025";
            // 
            // groupBox1
            // 
            groupBox1.Controls.Add(labelAIPort);
            groupBox1.Controls.Add(labelSQLPort);
            groupBox1.Controls.Add(labelAppPort);
            groupBox1.Controls.Add(labelServer);
            groupBox1.Controls.Add(labelActions);
            groupBox1.Controls.Add(button2);
            groupBox1.Controls.Add(labelAI);
            groupBox1.Controls.Add(button3);
            groupBox1.Controls.Add(buttonSQLStop);
            groupBox1.Controls.Add(labelSQL);
            groupBox1.Controls.Add(buttonSQLStart);
            groupBox1.Controls.Add(buttonStop);
            groupBox1.Controls.Add(labelModule);
            groupBox1.Controls.Add(buttonStart);
            groupBox1.Controls.Add(labelPort);
            groupBox1.Font = new Font("Segoe UI", 13.2000008F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            groupBox1.Location = new Point(13, 12);
            groupBox1.Name = "groupBox1";
            groupBox1.Size = new Size(496, 229);
            groupBox1.TabIndex = 42;
            groupBox1.TabStop = false;
            groupBox1.Text = "Service";
            // 
            // groupBox2
            // 
            groupBox2.Controls.Add(labelActive);
            groupBox2.Controls.Add(labelRTime);
            groupBox2.Controls.Add(labelNRequest);
            groupBox2.Controls.Add(labelNUser);
            groupBox2.Font = new Font("Segoe UI", 13.2000008F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            groupBox2.Location = new Point(13, 256);
            groupBox2.Name = "groupBox2";
            groupBox2.Size = new Size(340, 195);
            groupBox2.TabIndex = 43;
            groupBox2.TabStop = false;
            groupBox2.Text = "Server Information";
            // 
            // listLogSystem
            // 
            listLogSystem.Location = new Point(610, 22);
            listLogSystem.Multiline = true;
            listLogSystem.Name = "listLogSystem";
            listLogSystem.ScrollBars = ScrollBars.Both;
            listLogSystem.Size = new Size(443, 219);
            listLogSystem.TabIndex = 44;
            // 
            // linkGithub
            // 
            linkGithub.AutoSize = true;
            linkGithub.Location = new Point(286, 479);
            linkGithub.Name = "linkGithub";
            linkGithub.Size = new Size(56, 20);
            linkGithub.TabIndex = 45;
            linkGithub.TabStop = true;
            linkGithub.Text = "GitHub";
            linkGithub.LinkClicked += linkGithub_LinkClicked;
            // 
            // ViewServer
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = Color.AliceBlue;
            ClientSize = new Size(1061, 573);
            Controls.Add(linkGithub);
            Controls.Add(listLogSystem);
            Controls.Add(groupBox2);
            Controls.Add(groupBox1);
            Controls.Add(buttonClearLog);
            Controls.Add(listLogUser);
            Controls.Add(linkEmail);
            Controls.Add(linkFB);
            Controls.Add(labelContact);
            Controls.Add(pictureBox1);
            Controls.Add(linkWeb);
            FormBorderStyle = FormBorderStyle.FixedSingle;
            Icon = (Icon)resources.GetObject("$this.Icon");
            MaximizeBox = false;
            Name = "ViewServer";
            SizeGripStyle = SizeGripStyle.Hide;
            Text = "Server";
            Load += ViewServer_Load;
            ((System.ComponentModel.ISupportInitialize)pictureBox1).EndInit();
            groupBox1.ResumeLayout(false);
            groupBox1.PerformLayout();
            groupBox2.ResumeLayout(false);
            groupBox2.PerformLayout();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Button buttonStart;
        private Label labelPort;
        private LinkLabel linkWeb;
        private PictureBox pictureBox1;
        private Label labelContact;
        private LinkLabel linkFB;
        private LinkLabel linkEmail;
        private TextBox listLogUser;
        private Button buttonStop;
        private Button buttonClearLog;
        private Label labelActive;
        private Label labelNRequest;
        private Label labelNUser;
        private Label labelRTime;
        private Label labelWeb;
        private System.Windows.Forms.Timer timer1;
        private Label labelModule;
        private Button buttonSQLStart;
        private Label labelSQL;
        private Button buttonSQLStop;
        private Button button2;
        private Label labelAI;
        private Button button3;
        private Label labelActions;
        private Label labelServer;
        private Label labelAppPort;
        private Label labelSQLPort;
        private Label labelAIPort;
        private GroupBox groupBox1;
        private GroupBox groupBox2;
        private TextBox listLogSystem;
        private LinkLabel linkGithub;
    }
}
