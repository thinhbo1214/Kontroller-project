using System.Text.Json.Serialization;

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
        //[JsonPropertyName("username")]
        public string Username { get; set; }

        /// <summary>
        /// The password used to authenticate the user. Should be encrypted in storage.
        /// Optional:only visible to owner or admin.
        /// </summary>
        //[JsonPropertyName("password")]
        public string Password { get; set; }

        /// <summary>
        /// 
        /// </summary>
        //[JsonPropertyName("email")]
        public string? Email { get; set; }
        public Account()
        {
            Username = "";
            Password = "";
            Email = null;
        }
    }
}
