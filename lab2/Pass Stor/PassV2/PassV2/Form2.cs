using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace PassV2
{
    public partial class Form2 : Form
    {
        private Form1 form1;
        private Form3 form3;
        public Form2()
        {
            InitializeComponent();
            form1 = new Form1();
            form3 = new Form3(); 
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void Form2_Load(object sender, EventArgs e)
        {
            form1.ShowDialog();
            if (!GlobalVars.autoriz)
            {
                Application.Exit();                 // Завершить приложение
            }
            //GlobalVars.adpass = "123";
        }

        private void button1_Click(object sender, EventArgs e)
        {
            form3.ShowDialog();
        }
    }
}
