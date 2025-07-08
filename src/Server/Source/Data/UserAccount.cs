using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Server.Source.Data
{
    public class UserAccount
    {
        public string username { get; set; }
        public string password { get; set; }
        public UserAccount()
        {
            username = "";
            password = "";
        }
    }
}
