using Microsoft.IdentityModel.Tokens;
using Server.Source.Core;
using Server.Source.Helper;
using Server.Source.Model;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace Server.Source.View
{
    public partial class ConfigForm : Form
    {
        private bool isInitializing = false;

        public ConfigForm()
        {
            InitializeComponent();
        }

        private void radioButtonAuto_CheckedChanged(object sender, EventArgs e)
        {
            if (isInitializing) return;

            if (radioButtonAuto.Checked == true)
            {
                textBoxIP.Text = "";
                textBoxPort.Text = "";
                textBoxWWW.Text = "";
                textBoxCertificate.Text = "";

                textBoxIP.Enabled = false;
                textBoxPort.Enabled = false;
                textBoxWWW.Enabled = false;
                textBoxCertificate.Enabled = false;
                radioButtonManual.Checked = false;
                buttonSave.Enabled = true;
            }
        }

        private void radioButtonManual_CheckedChanged(object sender, EventArgs e)
        {
            if (isInitializing) return;

            if (radioButtonManual.Checked == true)
            {
                textBoxIP.Enabled = true;
                textBoxPort.Enabled = true;
                textBoxWWW.Enabled = true;
                textBoxCertificate.Enabled = true;

                textBoxIP.Text = "";
                textBoxPort.Text = "";
                textBoxWWW.Text = "";
                textBoxCertificate.Text = "";

                radioButtonAuto.Checked = false;
                buttonSave.Enabled = true;
            }
        }

        private void ConfigForm_Load(object sender, EventArgs e)
        {
            isInitializing = true;

            buttonSave.Enabled = false;
            var model = Simulation.GetModel<ModelServer>();
            radioButtonAuto.Checked = model.IsAutoConfig;
            radioButtonManual.Checked = !model.IsAutoConfig;

            if (model.IsAutoConfig)
            {
                textBoxIP.Text = "";
                textBoxPort.Text = "";
                textBoxWWW.Text = "";
                textBoxCertificate.Text = "";

                textBoxIP.Enabled = false;
                textBoxPort.Enabled = false;
                textBoxWWW.Enabled = false;
                textBoxCertificate.Enabled = false;
            }
            else
            {
                textBoxIP.Text = model.IP;
                textBoxPort.Text = model.Port.ToString();
                textBoxWWW.Text = model.WWW;
                textBoxCertificate.Text = model.Certificate;

                textBoxIP.Enabled = true;
                textBoxPort.Enabled = true;
                textBoxWWW.Enabled = true;
                textBoxCertificate.Enabled = true;
            }

            isInitializing = false;
        }

        private void groupBoxConfig_Enter(object sender, EventArgs e)
        {

        }

        private void buttonSave_Click(object sender, EventArgs e)
        {
            var model = Simulation.GetModel<ModelServer>();

            model.IsAutoConfig = radioButtonAuto.Checked;

            if (model.IsAutoConfig)
            {
                ConfigIPHelper.SetStaticIp();
                model.IP = ConfigIPHelper.GetCurrentIpAddress();
            }
            else
            {
                if (textBoxIP.Text.IsNullOrEmpty() || textBoxPort.Text.IsNullOrEmpty() || textBoxWWW.Text.IsNullOrEmpty() || textBoxCertificate.Text.IsNullOrEmpty())
                {
                    MessageBox.Show("Không được để trống!", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
                model.IP = textBoxIP.Text;

                if (!int.TryParse(textBoxPort.Text, out int port))
                {
                    MessageBox.Show("Port phải là số!", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }

                model.Port = int.Parse(textBoxPort.Text);
                model.WWW = textBoxWWW.Text;
                model.Certificate = textBoxCertificate.Text;
            }

            buttonSave.Enabled = false;
        }
    }
}
