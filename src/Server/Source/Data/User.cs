namespace Server.Source.Data
{
    /// <summary>
    /// Represents a user in the system, including personal information and game-related data.
    /// </summary>
    public class User
    {
        /// <summary>
        /// Unique identifier for the user.
        /// </summary>
        /// <example>'001'</example>
        public string UserId;

        /// <summary>
        /// Account credentials used for authentication (e.g., login form).
        /// </summary>
        public Account Account;

        /// <summary>
        /// Email address associated with the user. Optional:only visible to owner or admin.
        /// </summary>
        /// <example>'admin@kontroller.com'</example>
        public string Email;

        /// <summary>
        /// URL for the user's avatar image.
        /// </summary>
        /// <example>'https://example.com/avatar.jpg'</example>
        public string Avatar;

        /// <summary>
        /// Indicates whether the user is currently logged in.
        /// </summary>
        /// <example>true</example>
        public bool isLoggedIn;


        public User()
        {
            UserId = "";
            Account = new Account();
            Email = null;
            Avatar = null;
            isLoggedIn = false;

        }
    }
}
