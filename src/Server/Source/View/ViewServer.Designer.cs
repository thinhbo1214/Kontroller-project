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
            buttonStartApp = new Button();
            labelPort = new Label();
            linkWeb = new LinkLabel();
            pictureBox1 = new PictureBox();
            labelContact = new Label();
            linkFB = new LinkLabel();
            linkEmail = new LinkLabel();
            listLogUser = new TextBox();
            buttonStopApp = new Button();
            buttonClearLogsU = new Button();
            labelNRequest = new Label();
            labelNUser = new Label();
            labelRTime = new Label();
            timer1 = new System.Windows.Forms.Timer(components);
            labelModule = new Label();
            buttonStartSQL = new Button();
            labelSQL = new Label();
            buttonStopSQL = new Button();
            buttonStopAI = new Button();
            labelAI = new Label();
            buttonStartAI = new Button();
            labelActions = new Label();
            labelServer = new Label();
            labelAppPort = new Label();
            labelSQLPort = new Label();
            labelAIPort = new Label();
            groupBox1 = new GroupBox();
            groupBox2 = new GroupBox();
            listLogSystem = new TextBox();
            linkGithub = new LinkLabel();
            buttonNetstat = new Button();
            buttonCmd = new Button();
            buttonExplorer = new Button();
            buttonConfig = new Button();
            buttonServices = new Button();
            buttonHelp = new Button();
            buttonAnalyzeLogsU = new Button();
            buttonAnalyzeLogsS = new Button();
            buttonClearLogsS = new Button();
            labelCpuUsage = new Label();
            labelMemoryUsage = new Label();
            ((System.ComponentModel.ISupportInitialize)pictureBox1).BeginInit();
            groupBox1.SuspendLayout();
            groupBox2.SuspendLayout();
            SuspendLayout();
            // 
            // buttonStartApp
            // 
            buttonStartApp.BackColor = SystemColors.ButtonFace;
            buttonStartApp.Cursor = Cursors.Hand;
            buttonStartApp.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic);
            buttonStartApp.Location = new Point(291, 78);
            buttonStartApp.Name = "buttonStartApp";
            buttonStartApp.Size = new Size(94, 29);
            buttonStartApp.TabIndex = 0;
            buttonStartApp.Text = "Start";
            buttonStartApp.UseVisualStyleBackColor = false;
            buttonStartApp.Click += button1_Click;
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
            pictureBox1.Click += pictureBox1_Click;
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
            // buttonStopApp
            // 
            buttonStopApp.BackColor = SystemColors.ButtonFace;
            buttonStopApp.Cursor = Cursors.Hand;
            buttonStopApp.Enabled = false;
            buttonStopApp.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic);
            buttonStopApp.Location = new Point(391, 80);
            buttonStopApp.Name = "buttonStopApp";
            buttonStopApp.Size = new Size(94, 29);
            buttonStopApp.TabIndex = 15;
            buttonStopApp.Text = "Stop";
            buttonStopApp.UseVisualStyleBackColor = false;
            buttonStopApp.Click += buttonStop_Click;
            // 
            // buttonClearLogsU
            // 
            buttonClearLogsU.BackColor = SystemColors.ButtonFace;
            buttonClearLogsU.Cursor = Cursors.Hand;
            buttonClearLogsU.Location = new Point(959, 531);
            buttonClearLogsU.Name = "buttonClearLogsU";
            buttonClearLogsU.Size = new Size(94, 29);
            buttonClearLogsU.TabIndex = 16;
            buttonClearLogsU.Text = "Clear Logs";
            buttonClearLogsU.UseVisualStyleBackColor = false;
            buttonClearLogsU.Click += buttonClearLog_Click;
            // 
            // labelNRequest
            // 
            labelNRequest.AutoSize = true;
            labelNRequest.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelNRequest.Location = new Point(6, 81);
            labelNRequest.Name = "labelNRequest";
            labelNRequest.Size = new Size(183, 23);
            labelNRequest.TabIndex = 20;
            labelNRequest.Text = "Number of Request: 0";
            // 
            // labelNUser
            // 
            labelNUser.AutoSize = true;
            labelNUser.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelNUser.Location = new Point(6, 118);
            labelNUser.Name = "labelNUser";
            labelNUser.Size = new Size(156, 23);
            labelNUser.TabIndex = 22;
            labelNUser.Text = "Number of User: 0";
            // 
            // labelRTime
            // 
            labelRTime.AutoSize = true;
            labelRTime.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelRTime.Location = new Point(6, 44);
            labelRTime.Name = "labelRTime";
            labelRTime.Size = new Size(125, 23);
            labelRTime.TabIndex = 23;
            labelRTime.Text = "Running Time:";
            labelRTime.Click += labelRTime_Click;
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
            // buttonStartSQL
            // 
            buttonStartSQL.BackColor = SystemColors.ButtonFace;
            buttonStartSQL.Cursor = Cursors.Hand;
            buttonStartSQL.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic);
            buttonStartSQL.Location = new Point(291, 117);
            buttonStartSQL.Name = "buttonStartSQL";
            buttonStartSQL.Size = new Size(94, 29);
            buttonStartSQL.TabIndex = 30;
            buttonStartSQL.Text = "Start";
            buttonStartSQL.UseVisualStyleBackColor = false;
            buttonStartSQL.Click += buttonSQLStart_Click;
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
            // buttonStopSQL
            // 
            buttonStopSQL.BackColor = SystemColors.ButtonFace;
            buttonStopSQL.Cursor = Cursors.Hand;
            buttonStopSQL.Enabled = false;
            buttonStopSQL.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic);
            buttonStopSQL.Location = new Point(391, 115);
            buttonStopSQL.Name = "buttonStopSQL";
            buttonStopSQL.Size = new Size(94, 29);
            buttonStopSQL.TabIndex = 32;
            buttonStopSQL.Text = "Stop";
            buttonStopSQL.UseVisualStyleBackColor = false;
            buttonStopSQL.Click += buttonSQLStop_Click;
            // 
            // buttonStopAI
            // 
            buttonStopAI.BackColor = SystemColors.ButtonFace;
            buttonStopAI.Cursor = Cursors.Hand;
            buttonStopAI.Enabled = false;
            buttonStopAI.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic);
            buttonStopAI.Location = new Point(391, 150);
            buttonStopAI.Name = "buttonStopAI";
            buttonStopAI.Size = new Size(94, 29);
            buttonStopAI.TabIndex = 35;
            buttonStopAI.Text = "Stop";
            buttonStopAI.UseVisualStyleBackColor = false;
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
            // buttonStartAI
            // 
            buttonStartAI.BackColor = SystemColors.ButtonFace;
            buttonStartAI.Cursor = Cursors.Hand;
            buttonStartAI.Enabled = false;
            buttonStartAI.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic);
            buttonStartAI.Location = new Point(291, 152);
            buttonStartAI.Name = "buttonStartAI";
            buttonStartAI.Size = new Size(94, 29);
            buttonStartAI.TabIndex = 33;
            buttonStartAI.Text = "Start";
            buttonStartAI.UseVisualStyleBackColor = false;
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
            groupBox1.Controls.Add(buttonStopAI);
            groupBox1.Controls.Add(labelAI);
            groupBox1.Controls.Add(buttonStartAI);
            groupBox1.Controls.Add(buttonStopSQL);
            groupBox1.Controls.Add(labelSQL);
            groupBox1.Controls.Add(buttonStartSQL);
            groupBox1.Controls.Add(buttonStopApp);
            groupBox1.Controls.Add(labelModule);
            groupBox1.Controls.Add(buttonStartApp);
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
            groupBox2.Controls.Add(labelMemoryUsage);
            groupBox2.Controls.Add(labelCpuUsage);
            groupBox2.Controls.Add(labelRTime);
            groupBox2.Controls.Add(labelNRequest);
            groupBox2.Controls.Add(labelNUser);
            groupBox2.Font = new Font("Segoe UI", 13.2000008F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            groupBox2.Location = new Point(12, 247);
            groupBox2.Name = "groupBox2";
            groupBox2.Size = new Size(340, 217);
            groupBox2.TabIndex = 43;
            groupBox2.TabStop = false;
            groupBox2.Text = "Server Information";
            // 
            // listLogSystem
            // 
            listLogSystem.Location = new Point(615, 22);
            listLogSystem.Multiline = true;
            listLogSystem.Name = "listLogSystem";
            listLogSystem.ScrollBars = ScrollBars.Both;
            listLogSystem.Size = new Size(438, 178);
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
            // buttonNetstat
            // 
            buttonNetstat.BackColor = SystemColors.ButtonFace;
            buttonNetstat.Cursor = Cursors.Hand;
            buttonNetstat.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic);
            buttonNetstat.Location = new Point(515, 57);
            buttonNetstat.Name = "buttonNetstat";
            buttonNetstat.Size = new Size(94, 29);
            buttonNetstat.TabIndex = 46;
            buttonNetstat.Text = "Netstat";
            buttonNetstat.UseVisualStyleBackColor = false;
            buttonNetstat.Click += buttonNetstat_Click;
            // 
            // buttonCmd
            // 
            buttonCmd.BackColor = SystemColors.ButtonFace;
            buttonCmd.Cursor = Cursors.Hand;
            buttonCmd.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic);
            buttonCmd.Location = new Point(515, 92);
            buttonCmd.Name = "buttonCmd";
            buttonCmd.Size = new Size(94, 29);
            buttonCmd.TabIndex = 47;
            buttonCmd.Text = "CMD";
            buttonCmd.UseVisualStyleBackColor = false;
            buttonCmd.Click += buttonCmd_Click;
            // 
            // buttonExplorer
            // 
            buttonExplorer.BackColor = SystemColors.ButtonFace;
            buttonExplorer.Cursor = Cursors.Hand;
            buttonExplorer.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic);
            buttonExplorer.Location = new Point(515, 127);
            buttonExplorer.Name = "buttonExplorer";
            buttonExplorer.Size = new Size(94, 29);
            buttonExplorer.TabIndex = 48;
            buttonExplorer.Text = "Explorer";
            buttonExplorer.UseVisualStyleBackColor = false;
            buttonExplorer.Click += buttonExplorer_Click;
            // 
            // buttonConfig
            // 
            buttonConfig.BackColor = SystemColors.ButtonFace;
            buttonConfig.Cursor = Cursors.Hand;
            buttonConfig.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic);
            buttonConfig.Location = new Point(515, 22);
            buttonConfig.Name = "buttonConfig";
            buttonConfig.Size = new Size(94, 29);
            buttonConfig.TabIndex = 49;
            buttonConfig.Text = "Config";
            buttonConfig.UseVisualStyleBackColor = false;
            buttonConfig.Click += buttonConfig_Click;
            // 
            // buttonServices
            // 
            buttonServices.BackColor = SystemColors.ButtonFace;
            buttonServices.Cursor = Cursors.Hand;
            buttonServices.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic);
            buttonServices.Location = new Point(515, 162);
            buttonServices.Name = "buttonServices";
            buttonServices.Size = new Size(94, 29);
            buttonServices.TabIndex = 50;
            buttonServices.Text = "Services";
            buttonServices.UseVisualStyleBackColor = false;
            buttonServices.Click += buttonServices_Click;
            // 
            // buttonHelp
            // 
            buttonHelp.BackColor = SystemColors.ButtonFace;
            buttonHelp.Cursor = Cursors.Hand;
            buttonHelp.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic);
            buttonHelp.Location = new Point(515, 197);
            buttonHelp.Name = "buttonHelp";
            buttonHelp.Size = new Size(94, 29);
            buttonHelp.TabIndex = 51;
            buttonHelp.Text = "Help";
            buttonHelp.UseVisualStyleBackColor = false;
            buttonHelp.Click += buttonHelp_Click;
            // 
            // buttonAnalyzeLogsU
            // 
            buttonAnalyzeLogsU.BackColor = SystemColors.ButtonFace;
            buttonAnalyzeLogsU.Cursor = Cursors.Hand;
            buttonAnalyzeLogsU.Enabled = false;
            buttonAnalyzeLogsU.Location = new Point(836, 531);
            buttonAnalyzeLogsU.Name = "buttonAnalyzeLogsU";
            buttonAnalyzeLogsU.Size = new Size(117, 29);
            buttonAnalyzeLogsU.TabIndex = 52;
            buttonAnalyzeLogsU.Text = "Analyze Logs";
            buttonAnalyzeLogsU.UseVisualStyleBackColor = false;
            // 
            // buttonAnalyzeLogsS
            // 
            buttonAnalyzeLogsS.BackColor = SystemColors.ButtonFace;
            buttonAnalyzeLogsS.Cursor = Cursors.Hand;
            buttonAnalyzeLogsS.Enabled = false;
            buttonAnalyzeLogsS.Location = new Point(836, 206);
            buttonAnalyzeLogsS.Name = "buttonAnalyzeLogsS";
            buttonAnalyzeLogsS.Size = new Size(117, 29);
            buttonAnalyzeLogsS.TabIndex = 53;
            buttonAnalyzeLogsS.Text = "Analyze Logs";
            buttonAnalyzeLogsS.UseVisualStyleBackColor = false;
            // 
            // buttonClearLogsS
            // 
            buttonClearLogsS.BackColor = SystemColors.ButtonFace;
            buttonClearLogsS.Cursor = Cursors.Hand;
            buttonClearLogsS.Location = new Point(959, 206);
            buttonClearLogsS.Name = "buttonClearLogsS";
            buttonClearLogsS.Size = new Size(94, 29);
            buttonClearLogsS.TabIndex = 54;
            buttonClearLogsS.Text = "Clear Logs";
            buttonClearLogsS.UseVisualStyleBackColor = false;
            buttonClearLogsS.Click += buttonClearLogsS_Click;
            // 
            // labelCpuUsage
            // 
            labelCpuUsage.AutoSize = true;
            labelCpuUsage.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelCpuUsage.Location = new Point(6, 150);
            labelCpuUsage.Name = "labelCpuUsage";
            labelCpuUsage.Size = new Size(117, 23);
            labelCpuUsage.TabIndex = 24;
            labelCpuUsage.Text = "CPU Usage: 0";
            // 
            // labelMemoryUsage
            // 
            labelMemoryUsage.AutoSize = true;
            labelMemoryUsage.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelMemoryUsage.Location = new Point(6, 187);
            labelMemoryUsage.Name = "labelMemoryUsage";
            labelMemoryUsage.Size = new Size(148, 23);
            labelMemoryUsage.TabIndex = 25;
            labelMemoryUsage.Text = "Memory Usage: 0";
            // 
            // ViewServer
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = Color.AliceBlue;
            ClientSize = new Size(1061, 573);
            Controls.Add(buttonClearLogsS);
            Controls.Add(buttonAnalyzeLogsS);
            Controls.Add(buttonAnalyzeLogsU);
            Controls.Add(buttonHelp);
            Controls.Add(buttonServices);
            Controls.Add(buttonConfig);
            Controls.Add(buttonExplorer);
            Controls.Add(buttonCmd);
            Controls.Add(buttonNetstat);
            Controls.Add(linkGithub);
            Controls.Add(listLogSystem);
            Controls.Add(groupBox2);
            Controls.Add(groupBox1);
            Controls.Add(buttonClearLogsU);
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

        private Button buttonStartApp;
        private Label labelPort;
        private LinkLabel linkWeb;
        private PictureBox pictureBox1;
        private Label labelContact;
        private LinkLabel linkFB;
        private LinkLabel linkEmail;
        private TextBox listLogUser;
        private Button buttonStopApp;
        private Button buttonClearLogsU;
        private Label labelNRequest;
        private Label labelNUser;
        private Label labelRTime;
        private Label labelWeb;
        private System.Windows.Forms.Timer timer1;
        private Label labelModule;
        private Button buttonStartSQL;
        private Label labelSQL;
        private Button buttonStopSQL;
        private Button buttonStopAI;
        private Label labelAI;
        private Button buttonStartAI;
        private Label labelActions;
        private Label labelServer;
        private Label labelAppPort;
        private Label labelSQLPort;
        private Label labelAIPort;
        private GroupBox groupBox1;
        private GroupBox groupBox2;
        private TextBox listLogSystem;
        private LinkLabel linkGithub;
        private Button buttonNetstat;
        private Button buttonCmd;
        private Button buttonExplorer;
        private Button buttonConfig;
        private Button buttonServices;
        private Button buttonHelp;
        private Button buttonAnalyzeLogsU;
        private Button buttonAnalyzeLogsS;
        private Button buttonClearLogsS;
        private Label labelCpuUsage;
        private Label labelMemoryUsage;
    }
}
