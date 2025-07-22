namespace Server.Source.View
{
    partial class ConfigForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            groupBoxConfig = new GroupBox();
            buttonSave = new Button();
            radioButtonManual = new RadioButton();
            radioButtonAuto = new RadioButton();
            textBoxCertificate = new TextBox();
            textBoxWWW = new TextBox();
            textBoxPort = new TextBox();
            textBoxIP = new TextBox();
            labelCertificate = new Label();
            labelWWW = new Label();
            labelPort = new Label();
            labelIP = new Label();
            groupBoxConfig.SuspendLayout();
            SuspendLayout();
            // 
            // groupBoxConfig
            // 
            groupBoxConfig.Controls.Add(buttonSave);
            groupBoxConfig.Controls.Add(radioButtonManual);
            groupBoxConfig.Controls.Add(radioButtonAuto);
            groupBoxConfig.Controls.Add(textBoxCertificate);
            groupBoxConfig.Controls.Add(textBoxWWW);
            groupBoxConfig.Controls.Add(textBoxPort);
            groupBoxConfig.Controls.Add(textBoxIP);
            groupBoxConfig.Controls.Add(labelCertificate);
            groupBoxConfig.Controls.Add(labelWWW);
            groupBoxConfig.Controls.Add(labelPort);
            groupBoxConfig.Controls.Add(labelIP);
            groupBoxConfig.Dock = DockStyle.Fill;
            groupBoxConfig.Font = new Font("Segoe UI", 13.2000008F, FontStyle.Bold | FontStyle.Italic);
            groupBoxConfig.Location = new Point(0, 0);
            groupBoxConfig.Name = "groupBoxConfig";
            groupBoxConfig.Size = new Size(451, 288);
            groupBoxConfig.TabIndex = 0;
            groupBoxConfig.TabStop = false;
            groupBoxConfig.Text = "Server Configuration";
            groupBoxConfig.Enter += groupBoxConfig_Enter;
            // 
            // buttonSave
            // 
            buttonSave.BackColor = SystemColors.ButtonFace;
            buttonSave.Cursor = Cursors.Hand;
            buttonSave.Enabled = false;
            buttonSave.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic);
            buttonSave.Location = new Point(351, 253);
            buttonSave.Name = "buttonSave";
            buttonSave.Size = new Size(94, 29);
            buttonSave.TabIndex = 10;
            buttonSave.Text = "Save";
            buttonSave.UseVisualStyleBackColor = false;
            buttonSave.Click += buttonSave_Click;
            // 
            // radioButtonManual
            // 
            radioButtonManual.AutoSize = true;
            radioButtonManual.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            radioButtonManual.Location = new Point(268, 51);
            radioButtonManual.Name = "radioButtonManual";
            radioButtonManual.Size = new Size(91, 27);
            radioButtonManual.TabIndex = 9;
            radioButtonManual.TabStop = true;
            radioButtonManual.Text = "Manual";
            radioButtonManual.UseVisualStyleBackColor = true;
            radioButtonManual.CheckedChanged += radioButtonManual_CheckedChanged;
            // 
            // radioButtonAuto
            // 
            radioButtonAuto.AutoSize = true;
            radioButtonAuto.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            radioButtonAuto.Location = new Point(130, 51);
            radioButtonAuto.Name = "radioButtonAuto";
            radioButtonAuto.Size = new Size(113, 27);
            radioButtonAuto.TabIndex = 8;
            radioButtonAuto.TabStop = true;
            radioButtonAuto.Text = "Automatic";
            radioButtonAuto.UseVisualStyleBackColor = true;
            radioButtonAuto.CheckedChanged += radioButtonAuto_CheckedChanged;
            // 
            // textBoxCertificate
            // 
            textBoxCertificate.Location = new Point(130, 211);
            textBoxCertificate.Multiline = true;
            textBoxCertificate.Name = "textBoxCertificate";
            textBoxCertificate.Size = new Size(251, 33);
            textBoxCertificate.TabIndex = 7;
            // 
            // textBoxWWW
            // 
            textBoxWWW.Location = new Point(130, 172);
            textBoxWWW.Multiline = true;
            textBoxWWW.Name = "textBoxWWW";
            textBoxWWW.Size = new Size(251, 33);
            textBoxWWW.TabIndex = 6;
            // 
            // textBoxPort
            // 
            textBoxPort.Location = new Point(130, 133);
            textBoxPort.Multiline = true;
            textBoxPort.Name = "textBoxPort";
            textBoxPort.Size = new Size(251, 33);
            textBoxPort.TabIndex = 5;
            // 
            // textBoxIP
            // 
            textBoxIP.Location = new Point(130, 94);
            textBoxIP.Multiline = true;
            textBoxIP.Name = "textBoxIP";
            textBoxIP.Size = new Size(251, 33);
            textBoxIP.TabIndex = 4;
            // 
            // labelCertificate
            // 
            labelCertificate.AutoSize = true;
            labelCertificate.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelCertificate.Location = new Point(11, 221);
            labelCertificate.Name = "labelCertificate";
            labelCertificate.Size = new Size(97, 23);
            labelCertificate.TabIndex = 3;
            labelCertificate.Text = "Certificate:";
            // 
            // labelWWW
            // 
            labelWWW.AutoSize = true;
            labelWWW.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelWWW.Location = new Point(51, 182);
            labelWWW.Name = "labelWWW";
            labelWWW.Size = new Size(57, 23);
            labelWWW.TabIndex = 2;
            labelWWW.Text = "www:";
            // 
            // labelPort
            // 
            labelPort.AutoSize = true;
            labelPort.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelPort.Location = new Point(59, 143);
            labelPort.Name = "labelPort";
            labelPort.Size = new Size(49, 23);
            labelPort.TabIndex = 1;
            labelPort.Text = "Port:";
            // 
            // labelIP
            // 
            labelIP.AutoSize = true;
            labelIP.Font = new Font("Segoe UI", 10.2F, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point, 0);
            labelIP.Location = new Point(77, 104);
            labelIP.Name = "labelIP";
            labelIP.Size = new Size(31, 23);
            labelIP.TabIndex = 0;
            labelIP.Text = "IP:";
            // 
            // ConfigForm
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(451, 288);
            Controls.Add(groupBoxConfig);
            MaximizeBox = false;
            MinimizeBox = false;
            Name = "ConfigForm";
            ShowIcon = false;
            Text = "Config";
            Load += ConfigForm_Load;
            groupBoxConfig.ResumeLayout(false);
            groupBoxConfig.PerformLayout();
            ResumeLayout(false);
        }

        #endregion

        private GroupBox groupBoxConfig;
        private Label labelPort;
        private Label labelIP;
        private TextBox textBoxIP;
        private Label labelCertificate;
        private Label labelWWW;
        private TextBox textBoxCertificate;
        private TextBox textBoxWWW;
        private TextBox textBoxPort;
        private RadioButton radioButtonAuto;
        private RadioButton radioButtonManual;
        private Button buttonSave;
    }
}