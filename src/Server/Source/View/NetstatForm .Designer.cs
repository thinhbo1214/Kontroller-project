namespace Server.Source.View
{
    partial class NetstatForm
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
            dataGridViewNetstat = new DataGridView();
            Proto = new DataGridViewTextBoxColumn();
            LocalAddress = new DataGridViewTextBoxColumn();
            ForeignAddress = new DataGridViewTextBoxColumn();
            State = new DataGridViewTextBoxColumn();
            PID = new DataGridViewTextBoxColumn();
            ((System.ComponentModel.ISupportInitialize)dataGridViewNetstat).BeginInit();
            SuspendLayout();
            // 
            // dataGridViewNetstat
            // 
            dataGridViewNetstat.AllowUserToAddRows = false;
            dataGridViewNetstat.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells;
            dataGridViewNetstat.ColumnHeadersHeightSizeMode = DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            dataGridViewNetstat.Columns.AddRange(new DataGridViewColumn[] { Proto, LocalAddress, ForeignAddress, State, PID });
            dataGridViewNetstat.Dock = DockStyle.Fill;
            dataGridViewNetstat.Location = new Point(0, 0);
            dataGridViewNetstat.Name = "dataGridViewNetstat";
            dataGridViewNetstat.ReadOnly = true;
            dataGridViewNetstat.RowHeadersWidth = 51;
            dataGridViewNetstat.Size = new Size(585, 619);
            dataGridViewNetstat.TabIndex = 0;
            // 
            // Proto
            // 
            Proto.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
            Proto.Frozen = true;
            Proto.HeaderText = "Proto";
            Proto.MinimumWidth = 6;
            Proto.Name = "Proto";
            Proto.ReadOnly = true;
            Proto.Width = 74;
            // 
            // LocalAddress
            // 
            LocalAddress.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
            LocalAddress.Frozen = true;
            LocalAddress.HeaderText = "LocalAddress";
            LocalAddress.MinimumWidth = 6;
            LocalAddress.Name = "LocalAddress";
            LocalAddress.ReadOnly = true;
            LocalAddress.Width = 126;
            // 
            // ForeignAddress
            // 
            ForeignAddress.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
            ForeignAddress.Frozen = true;
            ForeignAddress.HeaderText = "ForeignAddress";
            ForeignAddress.MinimumWidth = 6;
            ForeignAddress.Name = "ForeignAddress";
            ForeignAddress.ReadOnly = true;
            ForeignAddress.Width = 141;
            // 
            // State
            // 
            State.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
            State.Frozen = true;
            State.HeaderText = "State";
            State.MinimumWidth = 6;
            State.Name = "State";
            State.ReadOnly = true;
            State.Width = 72;
            // 
            // PID
            // 
            PID.AutoSizeMode = DataGridViewAutoSizeColumnMode.AllCells;
            PID.Frozen = true;
            PID.HeaderText = "PID";
            PID.MinimumWidth = 6;
            PID.Name = "PID";
            PID.ReadOnly = true;
            PID.Width = 61;
            // 
            // NetstatForm
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(585, 619);
            Controls.Add(dataGridViewNetstat);
            FormBorderStyle = FormBorderStyle.FixedSingle;
            MaximizeBox = false;
            MinimizeBox = false;
            Name = "NetstatForm";
            ShowIcon = false;
            Text = "NetstatForm";
            ((System.ComponentModel.ISupportInitialize)dataGridViewNetstat).EndInit();
            ResumeLayout(false);
        }

        #endregion

        private DataGridView dataGridViewNetstat;
        private DataGridViewTextBoxColumn Proto;
        private DataGridViewTextBoxColumn LocalAddress;
        private DataGridViewTextBoxColumn ForeignAddress;
        private DataGridViewTextBoxColumn State;
        private DataGridViewTextBoxColumn PID;
    }
}