using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Microsoft.Win32;

namespace PassV2
{
    public partial class Form3 : Form
    {
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

        private void button1_Click(object sender, EventArgs e)
        {
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
            else if(newpass == newpass2)
            {
                MessageBox.Show("Пароль изменен!");
                GlobalVars.adpass = newpass;
                RegistryKey currentUserKey = Registry.CurrentUser;
                RegistryKey softwareKey = currentUserKey.OpenSubKey("Software", true);
                RegistryKey myKey = softwareKey.OpenSubKey("Kovalenko", true);
                myKey.SetValue("password", newpass);
                myKey.Close();
                softwareKey.Close();
                this.Close();
            }
            else
            {
                MessageBox.Show("Не подходит старый пароль!");
            }
        }
    }
}
