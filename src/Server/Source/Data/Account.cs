using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Server.Source.Data
{
    /// <summary>
    /// Account credentials used for authentication (e.g., login form).
    /// </summary>
    public class Account
    {
        /// <summary>
        /// The username used to log into the system.
        /// </summary>
        public string username { get; set; }

        /// <summary>
        /// The password used to authenticate the user. Should be encrypted in storage.
        /// Optional:only visible to owner or admin.
        /// </summary>
        public string password { get; set; }
        public Account()
        {
            username = "";
            password = "";
        }
    }
}
