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
        public Guid UserId { get; set; }

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

        public Guid DiaryId { get; set; }

        public List<Guid> ListId { get; set; }
        public int NumberList { get; set; }

        public List<Guid> Follower { get; set; }

        public int NumberFollower { get; set; }

        public List<Guid> Following { get; set; }

        public int NumberFollowing { get; set; }

        public List<Guid> ActivityId { get; set; }

        public List<Guid> ReviewId { get; set; }

        public List<Guid> ReactionId { get; set; }

        public List<Guid> CommentId { get; set; }

        public User()
        {
            UserId = Guid.Empty; // Có thể gán null
            Username = "";
            Email = "";
            Avatar = "";
            IsLoggedIn = false;
            NumberFollower = 0;
            NumberFollowing = 0;
            NumberList = 0;

            DiaryId = Guid.Empty;
            ListId = new List<Guid>();
            Follower = new List<Guid>();
            Following = new List<Guid>();
            ActivityId = new List<Guid>();
            ReviewId = new List<Guid>();
            CommentId = new List<Guid>();
            ReactionId = new List<Guid>();
        }
    }
}
