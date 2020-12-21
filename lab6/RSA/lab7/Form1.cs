using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Numerics;
using System.Windows.Forms;

namespace lab7
{
    public partial class Form1 : Form
    {
        private Form2 form2;
        public Form1()
        {
            InitializeComponent();
            form2 = new Form2();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            pgBar.Value = 0;
            pgBar.Visible = true;
            pgBar.Maximum = textBox4.Text.Length;
            string[] split = textBox7.Text.Split('-');
            string[] splitE = split[0].Split(':');
            string[] splitN = split[1].Split(':');
            string ms = textBox4.Text;
            BigInteger number;
            textBox5.Text = "";
            do
            {
                for (int i = 0; i < 8; i++)
                {
                    if (!ms.Equals(""))
                    {
                        int e1 = Convert.ToInt32(splitE[i], 16);
                        int n = Convert.ToInt32(splitN[i], 16);
                        char buf;
                        {
                            buf = ms[0];
                            ms = ms.Remove(0, 1);
                        }
                        number = BigInteger.Pow(buf, e1);
                        number = number % n;
                        int c = (int)number;
                        buf = (char)c;
                        textBox5.Text += buf.ToString();
                        pgBar.Value++;
                    }
                }
            } while (!ms.Equals(""));
            pgBar.Visible = false;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            progressBar1.Value = 0;
            progressBar1.Visible = true;
            progressBar1.Maximum = textBox3.Text.Length;
            string[] split = textBox2.Text.Split('-');
            string[] splitD = split[0].Split(':');
            string[] splitN = split[1].Split(':');
            string ms = textBox3.Text;
            BigInteger number;
            textBox8.Text = "";
            do
            {
                for (int i = 0; i < 8; i++)
                {
                    if (!ms.Equals(""))
                    {
                        int d = Convert.ToInt32(splitD[i], 16);
                        int n = Convert.ToInt32(splitN[i], 16);
                        char buf;
                        {
                            buf = ms[0];
                            ms = ms.Remove(0, 1);
                        }
                        number = BigInteger.Pow(buf, d);
                        number = number % n;
                        int c = (int)number;
                        buf = (char)c;
                        textBox8.Text += buf.ToString();
                        progressBar1.Value++;
                    }
                }
            } while (!ms.Equals(""));
            progressBar1.Visible = false;
        }


        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }
        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }
        private void textBox3_TextChanged(object sender, EventArgs e)
        {

        } 
        private void textBox5_TextChanged(object sender, EventArgs e)
        {

        }
        private void textBox4_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox6_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox7_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox8_TextChanged(object sender, EventArgs e)
        {

        }

        private void label8_Click(object sender, EventArgs e)
        {

        }

        private void label9_Click(object sender, EventArgs e)
        {

        }

        private void button3_Click(object sender, EventArgs e)
        {
            form2.ShowDialog();
        }

        private void textBox5_TextChanged_1(object sender, EventArgs e)
        {

        }

        private void pgBar_Click(object sender, EventArgs e)
        {

        }

        private void progressBar1_Click(object sender, EventArgs e)
        {

        }
    }
}
