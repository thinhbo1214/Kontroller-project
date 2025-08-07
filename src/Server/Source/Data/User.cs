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
        public Guid? UserId { get; set; }

        /// <summary>
        /// Account credentials used for authentication (e.g., login form).
        /// </summary>
        public string Username { get; set; }

        /// <summary>
        /// Email address associated with the user. Optional:only visible to owner or admin.
        /// </summary>
        /// <example>'admin@kontroller.com'</example>
        public string Email { get; set; }

        /// <summary>
        /// URL for the user's avatar image.
        /// </summary>
        /// <example>'https://example.com/avatar.jpg'</example>
        public string Avatar { get; set; }

        /// <summary>
        /// Indicates whether the user is currently logged in.
        /// </summary>
        /// <example>true</example>
        public bool IsLoggedIn { get; set; }


        public User()
        {
            UserId = null; // Có thể gán null
            Username = null;
            Email = null;
            Avatar = null;
            IsLoggedIn = false;

        }
    }
}
