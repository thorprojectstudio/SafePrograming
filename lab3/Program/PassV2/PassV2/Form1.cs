using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using Microsoft.Win32;
using System.Security.Cryptography;

namespace PassV2
{
    public partial class Form1 : Form
    {
        private Form3 form3;
        String pass;
        Random rnd = new Random();
        int[] mquest = new int[5];
        int[] passarr = new int[5];

        [DllImport("user32.dll", EntryPoint = "GetSystemMetrics")]
        public static extern int GetSystemMetrics(int nIndex);
        String patch;
        int mouse = GetSystemMetrics(43);

        public Form1()
        {
            InitializeComponent();
            form3 = new Form3();
            AutoCompleteStringCollection source = new AutoCompleteStringCollection()
            {
                "Admin"
            };
            textBox1.AutoCompleteCustomSource = source;
            textBox1.AutoCompleteMode = AutoCompleteMode.SuggestAppend;
            textBox1.AutoCompleteSource = AutoCompleteSource.CustomSource;

            RegistryKey currentUserKey = Registry.CurrentUser;
            RegistryKey softwareKey = currentUserKey.OpenSubKey("Software", true);
            RegistryKey myKey = softwareKey.OpenSubKey("Kovalenko", true);
            GlobalVars.adlogin = myKey.GetValue("login").ToString();
            GlobalVars.adpass = myKey.GetValue("password").ToString();

            if (myKey.GetValue("user").ToString() != SystemInformation.UserName && 
               myKey.GetValue("pcName").ToString() != Environment.MachineName &&
               myKey.GetValue("mouseKey").ToString() != mouse.ToString() &&
               myKey.GetValue("display").ToString() != SystemInformation.PrimaryMonitorSize.ToString())
            {
                MessageBox.Show("Не тот ПК");
                Application.Exit();                 // Завершить приложение
                myKey.Close();
                softwareKey.Close();
            }
          
            myKey.Close();
            softwareKey.Close();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {
            pass = textBox2.Text;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            MessageBox.Show("А зачем тогда было приходить?");
            Application.Exit();                 // Завершить приложение
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (textBox1.Text == "")
            {
                MessageBox.Show("Ну хоть что-то введите");
            }
            else if (!(GlobalVars.adlogin == textBox1.Text))
            {
                MessageBox.Show("Мы таких не знаем");
            }
            else if (pass == "")
            {
                MessageBox.Show("А пароль?");
            }
            //else if (pass.Length != 16)
            //{
            //    MessageBox.Show("Неверный пароль");
            //    textBox2.Text = "";
            //}
            else
            {
                if (heshGen() == pass)
                {
                    GlobalVars.autoriz = true;
                    this.Close();
                }
                else
                {
                    MessageBox.Show("Неверный пароль");
                    textBox2.Text = "";
                }

            }

        }

        private void button3_Click(object sender, EventArgs e)
        {
            form3.ShowDialog();
        }

        private string heshGen()
        {
            TimeSpan timeSpan = DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0);
            double curT_T0 = timeSpan.TotalSeconds;
            Random rd = new Random();
            int x = 30;
            long t = (long)curT_T0 / x;
            String k = GlobalVars.adpass;

            var enc = Encoding.ASCII;
            HMACSHA1 hmac = new HMACSHA1(enc.GetBytes(k));
            hmac.Initialize();

            byte[] buffer = enc.GetBytes(t.ToString());
            String key20 = BitConverter.ToString(hmac.ComputeHash(buffer)).Replace("-", "").ToLower();
            byte[] barr = Encoding.ASCII.GetBytes(key20);
            String key4 = barr[2].ToString() + barr[4].ToString() + barr[1].ToString() + barr[0].ToString();
            return key4;
        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            //for (int i = 0; i < 5; i++)
            //{
            //    mquest[i] = rnd.Next(0, GlobalVars.adpass.Length);
            //    label4.Text = label4.Text + mquest[i].ToString() + ",";
            //}
            //label4.Text = label4.Text + "?";
        }
    }
}
