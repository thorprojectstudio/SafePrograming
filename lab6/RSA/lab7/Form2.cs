using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace lab7
{
    public partial class Form2 : Form
    {
        byte[] easyC = { 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251 }; // Каждый раз считать алгоритмом не имеет смысла, а так Решето Эратосфена поможет
        public Form2()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Random rd = new Random();
            int[] p = new int[8];
            int[] q = new int[8];
            int[] n = new int[8];
            int[] f = new int[8];
            int[] d = new int[8];
            int[] em = new int[8];
            int[] k = new int[8];
            bool prime = true;
            int cou;
            textBox2.Text = "";
            textBox1.Text = "";
            for (int i = 0; i < 8; i++)
            {
                p[i] = easyC[rd.Next(0, 54)];
                q[i] = easyC[rd.Next(0, 54)];
                n[i] = p[i] * q[i];
                f[i] = (p[i] - 1) * (q[i] - 1);
                do
                {
                    prime = true;
                    k[i] = rd.Next(2, 6);
                    cou = k[i] * f[i] + 1;
                    for (int j = 2; j <= Math.Sqrt(cou); j++)
                    {
                        if (cou % j == 0)
                        {
                            prime = false;
                            break;
                        }
                    }
                    em[i] = rd.Next(3, 230);
                } while (prime);
                do
                {
                    em[i]--;
                    if (em[i] < 2)
                    {
                        em[i] = rd.Next(2, 255);
                    }
                }
                while (((k[i] * f[i] + 1) % em[i]) != 0);
                d[i] = (k[i] * f[i] + 1) / em[i];
            }
            for (int i = 0; i < 8; i++)
            {
                textBox2.Text += em[i].ToString("X3");
                textBox2.Text += ":";
                textBox1.Text += d[i].ToString("X3");
                textBox1.Text += ":";
            }
            textBox2.Text = textBox2.Text.Remove(textBox2.Text.Length - 1, 1);
            textBox1.Text = textBox1.Text.Remove(textBox1.Text.Length - 1, 1);
            textBox2.Text += "-";
            textBox1.Text += "-";
            for (int i = 0; i < 8; i++)
            {
                textBox2.Text += n[i].ToString("X4");
                textBox2.Text += ":";
                textBox1.Text += n[i].ToString("X4");
                textBox1.Text += ":";
            }
            textBox2.Text = textBox2.Text.Remove(textBox2.Text.Length - 1, 1);
            textBox1.Text = textBox1.Text.Remove(textBox1.Text.Length - 1, 1);
        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
