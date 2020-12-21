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

namespace lab3
{
    public partial class Form1 : Form
    {
        [DllImport("user32.dll", EntryPoint = "GetSystemMetrics")]
        public static extern int GetSystemMetrics(int nIndex);
        String patch;
        int mouse = GetSystemMetrics(43);
        public Form1()
        {
            
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        { 
           MessageBox.Show("Все нажимают отмена, а ты установи");
           Application.Exit();                 // Завершить приложение
        }

        private void button2_Click(object sender, EventArgs e)
        {
            try
            {
                if (patch == null)
                {
                    MessageBox.Show("А путь сам введется?");
                }
                else if (!CheckPath(patch))
                {
                    MessageBox.Show("И это вы называете путь?");
                }
                else
                {
                
                    byte[] resf;
                    resf = Properties.Resources.PassV2;
                    System.IO.File.WriteAllBytes(patch + "\\Program.exe", resf);
                    if (checkBox1.Checked == true)
                    {
                        string deskPath = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
                        ShortCut.Create(patch + "\\Program.exe", deskPath + "\\Program.lnk", "", "Тот самый ярлык, как и просили");
                    }
                    byte[] resf1;
                    resf1 = Properties.Resources.lab7;
                    System.IO.File.WriteAllBytes(patch + "\\KeyGen.exe", resf1);
                    if (checkBox1.Checked == true)
                    {
                        string deskPath = Environment.GetFolderPath(Environment.SpecialFolder.Desktop);
                        ShortCut.Create(patch + "\\KeyGen.exe", deskPath + "\\KeyGen.lnk", "", "Тот самый ярлык, как и просили");
                    }
                    MessageBox.Show("Программа установлена");

                    RegistryKey currentUserKey = Registry.CurrentUser;
                    RegistryKey softwareKey = currentUserKey.OpenSubKey("Software", true);
                    RegistryKey myKey = softwareKey.CreateSubKey("Kovalenko");
                    myKey.SetValue("user", SystemInformation.UserName);
                    myKey.SetValue("pcName", Environment.MachineName);
                    myKey.SetValue("mouseKey", mouse.ToString());
                    myKey.SetValue("display", SystemInformation.PrimaryMonitorSize.ToString());
                    myKey.SetValue("login", "Admin");
                    myKey.SetValue("password", "admin");
                    myKey.Close();
                    softwareKey.Close();

                    Application.Exit(); // Завершить приложение
                }
            }
            catch (Exception exception)
            {
                MessageBox.Show(exception.Message);
            }
        }

        internal bool CheckPath(string path)
        {

            if (!string.IsNullOrEmpty(path))
            {
                for (int i = 0; i < path.Length; i++)
                {
                    if (path[i] == '\\' || path[i] == ':')
                        return true;
                }
            }
            return false;
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            patch = textBox1.Text;
        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {

        }

        private void checkBox2_CheckedChanged(object sender, EventArgs e)
        {
            if (checkBox2.Checked == true)
            {
                MessageBox.Show("Вы подписались на 5-ку этому студенту");
            }
            else
            {
                MessageBox.Show("К сожелению отписались");
            }
        }
        private void checkBox3_CheckedChanged(object sender, EventArgs e)
        {
            if (checkBox3.Checked == true)
            {
                MessageBox.Show("А может не надо?");
            }
            else
            {
                MessageBox.Show("Спасибо!");
            }
        }
        static class ShellLink
        {
            [ComImport,
            Guid("000214F9-0000-0000-C000-000000000046"),
            InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
            internal interface IShellLinkW
            {
                [PreserveSig]
                int GetPath(
                    [Out, MarshalAs(UnmanagedType.LPWStr)]
                StringBuilder pszFile,
                    int cch, ref IntPtr pfd, uint fFlags);

                [PreserveSig]
                int GetIDList(out IntPtr ppidl);

                [PreserveSig]
                int SetIDList(IntPtr pidl);

                [PreserveSig]
                int GetDescription(
                    [Out, MarshalAs(UnmanagedType.LPWStr)]
                StringBuilder pszName, int cch);

                [PreserveSig]
                int SetDescription(
                    [MarshalAs(UnmanagedType.LPWStr)]
                string pszName);

                [PreserveSig]
                int GetWorkingDirectory(
                    [Out, MarshalAs(UnmanagedType.LPWStr)]
                StringBuilder pszDir, int cch);

                [PreserveSig]
                int SetWorkingDirectory(
                    [MarshalAs(UnmanagedType.LPWStr)]
                string pszDir);

                [PreserveSig]
                int GetArguments(
                    [Out, MarshalAs(UnmanagedType.LPWStr)]
                StringBuilder pszArgs, int cch);

                [PreserveSig]
                int SetArguments(
                    [MarshalAs(UnmanagedType.LPWStr)]
                string pszArgs);

                [PreserveSig]
                int GetHotkey(out ushort pwHotkey);

                [PreserveSig]
                int SetHotkey(ushort wHotkey);

                [PreserveSig]
                int GetShowCmd(out int piShowCmd);

                [PreserveSig]
                int SetShowCmd(int iShowCmd);

                [PreserveSig]
                int GetIconLocation(
                    [Out, MarshalAs(UnmanagedType.LPWStr)]
                StringBuilder pszIconPath, int cch, out int piIcon);

                [PreserveSig]
                int SetIconLocation(
                    [MarshalAs(UnmanagedType.LPWStr)]
                string pszIconPath, int iIcon);

                [PreserveSig]
                int SetRelativePath(
                    [MarshalAs(UnmanagedType.LPWStr)]
                string pszPathRel, uint dwReserved);

                [PreserveSig]
                int Resolve(IntPtr hwnd, uint fFlags);

                [PreserveSig]
                int SetPath(
                    [MarshalAs(UnmanagedType.LPWStr)]
                string pszFile);
            }

            [ComImport,
            Guid("00021401-0000-0000-C000-000000000046"),
            ClassInterface(ClassInterfaceType.None)]
            private class shl_link { }

            internal static IShellLinkW CreateShellLink()
            {
                return (IShellLinkW)(new shl_link());
            }
        }

        public static class ShortCut
        {
            public static void Create(
                string PathToFile, string PathToLink,
                string Arguments, string Description)
            {
                ShellLink.IShellLinkW shlLink = ShellLink.CreateShellLink();

                Marshal.ThrowExceptionForHR(shlLink.SetDescription(Description));
                Marshal.ThrowExceptionForHR(shlLink.SetPath(PathToFile));
                Marshal.ThrowExceptionForHR(shlLink.SetArguments(Arguments));

                ((System.Runtime.InteropServices.ComTypes.IPersistFile)shlLink).Save(PathToLink, false);
            }
        }
    }
}
