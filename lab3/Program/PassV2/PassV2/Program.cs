using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace PassV2
{
    public class GlobalVars
    {
        public static String adlogin;
        public static String adpass;
        public static bool autoriz;
    }
    static class Program
    {
        /// <summary>
        /// Главная точка входа для приложения.
        /// </summary>
        [STAThread]
        static void Main()
        {
            GlobalVars.adlogin = "Admin";
            GlobalVars.adpass = "admin";
            GlobalVars.autoriz = false;
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new Form2());
            
        }
    }
}
