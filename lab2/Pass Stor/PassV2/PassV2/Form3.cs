using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Microsoft.Win32;

namespace PassV2
{
    public partial class Form3 : Form
    {
        String oldpass;
        String newpass;
        String newpass2;
        public Form3()
        {
            InitializeComponent();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            newpass = textBox1.Text;
        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {
            newpass2 = textBox2.Text;
        }

        private void textBox3_TextChanged(object sender, EventArgs e)
        {
            oldpass = textBox3.Text;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            RegistryKey currentUserKey = Registry.CurrentUser;
            RegistryKey softwareKey = currentUserKey.OpenSubKey("Software", true);
            RegistryKey myNKey = softwareKey.OpenSubKey("Kovalenko", true);
            RegistryKey myKey = myNKey.OpenSubKey("Lab2", true);

            oldpass = heshGen(oldpass);

            if (newpass == null || newpass2 == null)
            {
                MessageBox.Show("Ну хоть что-то введите");
                newpass = "                             ";
                newpass2 = "                            ";
            }
            else if (!(newpass == newpass2))
            {
                MessageBox.Show("Пароли не совпадают!");
            }
            else if(oldpass == myKey.GetValue("password").ToString() && (newpass == newpass2))
            {
                MessageBox.Show("Пароль изменен!");
                newpass = heshGen(newpass);
                GlobalVars.adpass = newpass;
                myKey.SetValue("password", newpass);
                this.Close();
            }
            else
            {
                MessageBox.Show("Не подходит старый пароль!");
            }
            myKey.Close();
            myNKey.Close();
            softwareKey.Close();
        }

        private String heshGen(String pass)
        {
            //String a = "1";

            var enc = Encoding.ASCII;
            HMACSHA1 hmac = new HMACSHA1(enc.GetBytes(pass));
            hmac.Initialize();

            byte[] buffer = enc.GetBytes(pass);
            String key20 = BitConverter.ToString(hmac.ComputeHash(buffer)).Replace("-", "").ToLower();

            return key20;
            //textBox2.Text = key20;
        }
    }
}
